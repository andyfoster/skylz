# frozen_string_literal: true

class SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_skillset
  before_action :set_skill, only: %i[show edit update destroy]
  before_action :prepare_skillset

  # GET /skills or /skills.json
  def index
    scope = current_user.skills.where(skillset: @skillset).includes(:activities)
    @tags = scope.pluck(:tags).join(',').split(',').map(&:strip).reject(&:blank?).uniq.sort
    scope = scope.where('skills.name ILIKE ? OR skills.notes ILIKE ?', "%#{Skill.sanitize_sql_like(params[:q].to_s.strip)}%", "%#{Skill.sanitize_sql_like(params[:q].to_s.strip)}%") if params[:q].present?
    @skills = scope.to_a
    @skills.select! { |skill| skill.tags.to_s.split(',').map(&:strip).include?(params[:tag]) } if params[:tag].present?
    @skills = case params[:sort]
              when 'name' then @skills.sort_by { |skill| skill.name.downcase }
              when 'recent' then @skills.sort_by { |skill| skill.activities.map { |a| a.date || a.created_at.to_date }.max || Date.new(1900) }.reverse
              else @skills.sort_by { |skill| [-skill.total_reps, skill.name.downcase] }
              end
  end

  # Render  fragment in a format
  # Perform basic search on search params
  # should be case insensitive
  def skillList
    @skillset = active_skillset
    @skills = current_user.skills.where(skillset_id: @skillset.id).where('name ILIKE ?', "%#{params[:q]}%")

    render partial: 'skillList', locals: { skills: @skills }
  end

  # Return a json object with axample data for skill name, notes, and steps
  def generate
    if ENV['OPENAI_API_KEY'].blank?
      return render json: { error: 'AI drafting is not configured. You can still enter your skill manually.' }, status: :service_unavailable
    end
    answer = ChatgptService.call(params[:message])
    data = JSON.parse(answer.strip.sub(/\A```(?:json)?\s*/, '').sub(/\s*```\z/, ''))
    valid = data.is_a?(Hash) && data['reason'].is_a?(String) &&
      (data['notes'] || data['note']).is_a?(String) &&
      %w[steps tags].all? { |field| data[field].is_a?(Array) && data[field].all? { |item| item.is_a?(String) } }
    raise JSON::ParserError unless valid
    render json: { reason: data['reason'], notes: data['notes'] || data['note'], steps: data['steps'], tags: data['tags'] }
  rescue ChatgptService::IncompleteDraft
    render json: { error: 'The draft was incomplete. Please try again with a shorter skill description.' }, status: :bad_gateway
  rescue JSON::ParserError
    render json: { error: 'The draft could not be read. Please try again.' }, status: :bad_gateway
  rescue StandardError => error
    Rails.logger.warn("Skill drafting failed: #{error.class}")
    render json: { error: 'Draft generation is unavailable. Please try again later.' }, status: :bad_gateway
  end

  def export
    @skills = current_user.skills.where(skillset: active_skillset)
  end

  # GET /skills/1 or /skills/1.json
  def show
    @skill = current_user.skills.find(params[:id])
    # TODO: where(is_deleted: false)
  end

  # GET /skills/new
  def new
    @skillset = active_skillset
    @skill = Skill.new
    # @skill = current_user.skills.build
  end

  # GET /skills/1/edit
  def edit; end

  def new_multi
    @skillset = active_skillset
    @skill = Skill.new
  end

  def create_multi
    @skill = current_user.skills.build(skill_params.except(:name))
    names = params.dig(:skill, :name).to_s.lines.map(&:strip).reject(&:blank?).uniq
    begin
      raise ActiveRecord::RecordInvalid.new(@skill) if names.empty?
      Skill.transaction do
        names.each { |name| current_user.skills.create!(skill_params.merge(name: name)) }
      end
      redirect_to skills_path, notice: "#{names.size} skills added."
    rescue ActiveRecord::RecordInvalid => error
      @skill = error.record
      @skill.errors.add(:name, 'Enter at least one skill.') if names.empty?
      render :new_multi, status: :unprocessable_entity
    end
  end

  # POST /skills or /skills.json
  def create
    # @skill = Skill.new(skill_params)
    @skill = current_user.skills.build(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to skill_url(@skill) }
        format.json { render :show, status: :created, location: @skill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skills/1 or /skills/1.json
  def update
    respond_to do |format|
      if @skill.update(skill_params)
        format.html { redirect_to skill_url(@skill), notice: 'Skill was successfully updated.' }
        format.json { render :show, status: :ok, location: @skill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1 or /skills/1.json
  def destroy
    if @skill.destroy
      redirect_to skills_path, notice: 'Skill deleted.'
    else
      redirect_to @skill, alert: @skill.errors.full_messages.to_sentence
    end
  end

  # get /s/medical
  def tag_search; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skill
    @skill = current_user.skills.find(params[:id])
  end

  def prepare_skillset
    @skillset = @skill&.skillset || active_skillset
  end

  # Only allow a list of trusted parameters through.
  def skill_params
    params.fetch(:skill, {}).permit(:name, :notes, :media, :tags, :steps, :category,
                                    :skillset_id, :reason).merge(user_id: current_user.id)
  end
end
