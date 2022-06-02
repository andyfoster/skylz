class SkillsController < ApplicationController
  before_action :set_skill, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /skills or /skills.json
  def index
    @domain = Domain.find(current_user.current_domain)
    @skills = current_user.skills.where(domain_id: @domain.id).order("created_at DESC")
  end

  # GET /skills/1 or /skills/1.json
  def show
    @skill = current_user.skills.find(params[:id])
    # TODO: where(is_deleted: false)
  end

  # GET /skills/new
  def new
    @domain = Domain.find(current_user.current_domain)
    @skill = Skill.new
    # @skill = current_user.skills.build
  end

  # GET /skills/1/edit
  def edit
    @domain = Domain.find(current_user.current_domain)
    @skill = current_user.skills.find(params[:id])
  end

  def new_multi
    @domain = Domain.find(current_user.current_domain)
    @skill = Skill.new
  end

def create_multi
    # @skill = @skill = current_user.skills.build(skill_params)

    skill_array = Array.new
    params[:skill][:name].split("\n").reject(&:blank?).each do |skill_name|
      skill_array.push({ name: skill_name, user_id: current_user.id, 
        domain_id: current_user.current_domain, tags: params[:skill][:tags] })
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
        format.html { redirect_to skill_url(@skill)}
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
        format.html { redirect_to skill_url(@skill), notice: "Skill was successfully updated." }
        format.json { render :show, status: :ok, location: @skill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1 or /skills/1.json
  def destroy
    @skill.destroy
    # TODO - update is_deleted to true

    respond_to do |format|
      format.html { redirect_to skills_url, notice: "Skill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # get /s/medical
  def tag_search
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.fetch(:skill, {}).permit(:name, :notes, :media, :tags, :steps, :category, :domain_id).merge(user_id: current_user.id)
    end
end
