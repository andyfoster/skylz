class SkillSessionsController < ApplicationController
  before_action :set_skill_session, only: %i[ show edit update destroy ]

  # GET /skill_sessions or /skill_sessions.json
  def index
    @skill_sessions = SkillSession.all
  end

  # GET /skill_sessions/1 or /skill_sessions/1.json
  def show
  end

  # GET /skill_sessions/new
  def new
    @skill_session = SkillSession.new
    3.times { @skill_session.activities.build }
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
    params.require(:skill_session).permit(:date, :notes, activities_attributes: [:id, :name, :reps, :_destroy])

  end
end
