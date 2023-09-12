# frozen_string_literal: true

class SkillsController < ApplicationController
  before_action :set_skill, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /skills or /skills.json
  def index
    # TODO: fix situation if a the current skillset has been deleted
    # if Skillset.find(current_user.current_skillset).exists?
    @skillset = Skillset.find(current_user.current_skillset)
    # else
    # @skillset = current_user.skillsets.first
    # end
    @tags = Skill.where(user_id: current_user.id, skillset_id: @skillset.id)
                 .pluck(:tags).join(',').split(',').collect(&:strip).uniq.reject(&:blank?)
    @skills = current_user.skills.where(skillset_id: @skillset.id).sort_by(&:total_reps).reverse
  end


  # Return a json object with axample data for skill name, notes, and steps
  def generate
    # @skill = Skill.new
    # @skill.name = Faker::Hacker.verb
    # @skill.notes = Faker::Hacker.say_something_smart
    # @skill.steps = Faker::Hacker.say_something_smart
    # @skill.tags = Faker::Hacker.ingverb
    # @skill.category = Faker::Hacker.adjective
    # @skill.reason = Faker::Hacker.abbreviation
    # @skill.media = Faker::Internet.url
    # @skill.save
    # render json: @skill
    # Use the openAi API
    # @response = ChatgptService.call(params[:message])

    @answer = ChatgptService.call(params[:message], 'gpt-3.5-turbo')

    # convert the response to a json array
    @answer = @answer.split("\n").reject(&:blank?).to_json

    # render json: @answer

    render json: { data: @answer }

    # render json: {
    #   name: "Skill from API",
    #   notes: "The bow and arrow choke is a highly effective submission in Brazilian Jiu-Jitsu. It's an aggressive move that can finish a match quickly if applied correctly. Take your time to properly get your grips and secure your positioning to successfully apply this choke. It requires a steady balance along with a tight grip. Check out online tutorials or seek guidance from a professional coach to perfect this skill. Always remember safety first.",
    #   steps: [ "*Secure control of your opponent's collars*",
    #   "Grip the collar of your opponent from under their arm and across their neck.",
    #   "Transition to their back and maintain control by gripping their pants at the knee, this is your 'bow'.",
    #   "Pull your opponent onto their side, swing your leg over their shoulder and hook their arm, this is your 'arrow'.",
    #   "Pull back on both grips while pushing your leg against their back for the choke."],
    #   tags: ["tag1", "tag2"],
    #   reason: "When you want to destory the opponent",
    # }
  end

  def export
    @skills = current_user.skills.where(skillset_id: current_user.current_skillset)
    # respond_to do |format|
    #   format.csv { send_data @skills.to_csv, filename: 'skills.csv' }
    # end
  end

  # GET /skills/1 or /skills/1.json
  def show
    @skill = current_user.skills.find(params[:id])
    # TODO: where(is_deleted: false)
  end

  # GET /skills/new
  def new
    @skillset = Skillset.find(current_user.current_skillset)
    @skill = Skill.new
    # @skill = current_user.skills.build
  end

  # GET /skills/1/edit
  def edit
    @skillset = Skillset.find(current_user.current_skillset)
    @skill = current_user.skills.find(params[:id])
  end

  def new_multi
    @skillset = Skillset.find(current_user.current_skillset)
    @skill = Skill.new
  end

  def create_multi
    # @skill = @skill = current_user.skills.build(skill_params)

    skill_array = []
    params[:skill][:name].split("\n").reject(&:blank?).each do |skill_name|
      skill_array.push({ name: skill_name, user_id: current_user.id,
                         skillset_id: params[:skill][:skillset_id], tags: params[:skill][:tags] })
    end

    if Skill.insert_all(skill_array)
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end

    # redirect_to skills_url, notice: "#{params[:skill][:name].count + 1} skills were successfully created."

    # respond_to do |format|
    #   if @skill.save
    #     format.html redirect_to root_url
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #   end
    # end
  end

  # POST /skills or /skills.json
  def create
    # @skill = Skill.new(skill_params)
    @skill = @skill = current_user.skills.build(skill_params)

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
    if @skill.present?
      @skill.destroy
      redirect_to skills_url
    end
    # TODO: - update is_deleted to true

    # respond_to do |format|
    #   format.html { redirect_to skills_url, notice: 'Skill was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  # get /s/medical
  def tag_search; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skill
    @skill = Skill.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skill_params
    params.fetch(:skill, {}).permit(:name, :notes, :media, :tags, :steps, :category,
                                    :skillset_id, :reason).merge(user_id: current_user.id)
  end
end
