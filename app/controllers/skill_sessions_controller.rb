class SkillSessionsController < ApplicationController
  before_action :set_skill_session, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :current_skillset # pass down the current skillset to every view

  # GET /skill_sessions or /skill_sessions.json
  def index
    @skill_sessions = SkillSession.all.includes([:activities])
    @skill_sessions = @skill_sessions.sort_by(&:date).reverse
  end

  # GET /skill_sessions/1 or /skill_sessions/1.json
  def show
  end

  #  Hmm CCoPilot just wrote all these for me. Need a lot of testing
  # Save the skill session as a PDF
  # def save_as_pdf
  #   @skill_session = SkillSession.find(params[:id])
  #   respond_to do |format|
  #     format.html
  #     format.text
  #     format.pdf do
  #       pdf = SkillSessionPdf.new(@skill_session, view_context)
  #       send_data pdf.render, filename: "skill_session.pdf",
  #                             type: "application/pdf",
  #                             disposition: "inline"
  #     end
  #   end
  # end


  # Save the skill session as a template
  # def save_as_template

  #   @skill_session = SkillSession.find(params[:id])
  #   @skill_session_template = SkillSessionTemplate.new
  #   @skill_session_template.skill_session_id = @skill_session.id
  #   @skill_session_template.name = @skill_session.name
  #   @skill_session_template.date = @skill_session.date
  #   @skill_session_template.notes = @skill_session.notes
  #   @skill_session_template.user_id = @skill_session.user_id
  #   @skill_session_template.skill_id = @skill_session.skill_id
  #   @skill_session_template.save

  #   @skill_session.activities.each do |activity|
  #     @skill_session_template_activity = SkillSessionTemplateActivity.new
  #     @skill_session_template_activity.skill_session_template_id = @skill_session_template.id
  #     @skill_session_template_activity.name = activity.name
  #     @skill_session_template_activity.reps = activity.reps
  #     @skill_session_template_activity.description = activity.description
  #     @skill_session_template_activity.rating = activity.rating
  #     @skill_session_template_activity.skill_id = activity.skill_id
  #     @skill_session_template_activity.user_id = activity.user_id
  #     @skill_session_template_activity.date = activity.date
  #     @skill_session_template_activity.activity_type = activity.activity_type
  #     @skill_session_template_activity.save
  #   end

  #   respond_to do |format|
  #     format.html { redirect_to skill_session_url(@skill_session), notice: "Skill session was successfully saved as a template." }
  #     format.json { render :show, status: :created, location: @skill_session }
  #   end
  # end

  # # GET /skill_sessions/new_from_template
  # def new_from_template
  #   @skill_session_template = SkillSessionTemplate.find(params[:id])
  #   @skill_session = SkillSession.new
  #   @skill_session.name = @skill_session_template.name
  #   @skill_session.date = @skill_session_template.date
  #   @skill_session.notes = @skill_session_template.notes
  #   @skill_session.user_id = @skill_session_template.user_id
  #   @skill_session.skill_id = @skill_session_template.skill_id
  #   @skill_session.save

  #   @skill_session_template.skill_session_template_activities.each do |activity|
  #     @skill_session_activity = Activity.new
  #     @skill_session_activity.skill_session_id = @skill_session.id
  #     @skill_session_activity.name = activity.name
  #     @skill_session_activity.reps = activity.reps
  #     @skill_session_activity.description = activity.description
  #     @skill_session_activity.rating = activity.rating
  #     @skill_session_activity.skill_id = activity.skill_id
  #     @skill_session_activity.user_id = activity.user_id
  #     @skill_session_activity.date = activity.date
  #     @skill_session_activity.activity_type = activity.activity_type
  #     @skill_session_activity.save
  #   end

  #   respond_to do |format|
  #     format.html { redirect_to skill_session_url(@skill_session), notice: "Skill session was successfully created." }
  #     format.json { render :show, status: :created, location: @skill_session }
  #   end
  # end

  # GET /skill_sessions/new_from_skill
  def new_from_skill
    @skill = Skill.find(params[:id])
    @skill_session = SkillSession.new
    @skill_session.name = @skill.name
    @skill_session.skill_id = @skill.id
    @skill_session.save

    @skill.activities.each do |activity|
      @skill_session_activity = Activity.new
      @skill_session_activity.skill_session_id = @skill_session.id
      @skill_session_activity.name = activity.name
      @skill_session_activity.reps = activity.reps
      @skill_session_activity.description = activity.description
      @skill_session_activity.rating = activity.rating
      @skill_session_activity.skill_id = activity.skill_id
      @skill_session_activity.user_id = activity.user_id
      @skill_session_activity.date = activity.date
      @skill_session_activity.activity_type = activity.activity_type
      @skill_session_activity.save
    end

    respond_to do |format|
      format.html { redirect_to skill_session_url(@skill_session), notice: "Skill session was successfully created." }
      format.json { render :show, status: :created, location: @skill_session }
    end
  end

  # GET /skill_sessions/new
  def new
    if params[:skill_id] # if skill_id is passed in, pre-populate the skill_id
      # @skill_session = SkillSession.new(skill_id: params[:skill_id])
      @session_for_skill = params[:skill_id]
    end

    @skill_session = SkillSession.new
    @skill_session.activities.build
  end

  # GET /skill_sessions/1/edit
  def edit
  end

  # POST /skill_sessions or /skill_sessions.json
  def create
    @skill_session = SkillSession.new(skill_session_params)

    respond_to do |format|
      if @skill_session.save
        format.html { redirect_to skill_session_url(@skill_session), notice: "Skill session was successfully created." }
        format.json { render :show, status: :created, location: @skill_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skill_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skill_sessions/1 or /skill_sessions/1.json
  def update
    respond_to do |format|
      if @skill_session.update(skill_session_params)
        format.html { redirect_to skill_session_url(@skill_session), notice: "Skill session was successfully updated." }
        format.json { render :show, status: :ok, location: @skill_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skill_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skill_sessions/1 or /skill_sessions/1.json
  def destroy
    @skill_session.destroy

    respond_to do |format|
      format.html { redirect_to skill_sessions_url, notice: "Skill session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skill_session
    @skill_session = SkillSession.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skill_session_params
    params.require(:skill_session).permit(:date, :notes,
      activities_attributes: [:id, :name, :reps, :description,
        :rating, :skill_id, :user_id, :date, :activity_type, :_destroy])
        .merge({ user_id: current_user.id })
  end

  def current_skillset
    @current_skillset = current_user.current_skillset
  end
end
