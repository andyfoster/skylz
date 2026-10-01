class SkillSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_skillset
  before_action :set_skill_session, only: %i[show edit update destroy]
  before_action :prepare_skills

  def index
    @skill_sessions = current_user.skill_sessions.joins(activities: :skill)
      .where(skills: { skillset_id: active_skillset.id }).distinct
      .includes(activities: :skill).order(date: :desc, id: :desc)
  end

  def show; end

  def new
    @skill_session = current_user.skill_sessions.build(date: Date.current, type: 'Solo Drills')
    if params[:skill_id].present?
      skill = current_user.skills.find(params[:skill_id])
      @session_skills = current_user.skills.where(skillset: skill.skillset).order(:name)
    end
    @skill_session.activities.build(skill: skill, reps: 1)
  end

  def edit; end

  def create
    @skill_session = current_user.skill_sessions.build(skill_session_params)
    if @skill_session.save
      redirect_to @skill_session, notice: 'Session saved.'
    else
      prepare_skills
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @skill_session.update(skill_session_params)
      redirect_to @skill_session, notice: 'Session updated.'
    else
      prepare_skills
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @skill_session.destroy!
    redirect_to skill_sessions_path, notice: 'Session deleted.'
  end

  private

  def set_skill_session
    @skill_session = current_user.skill_sessions.find(params[:id])
  end

  def prepare_skills
    # Existing activities may belong to another skillset; preserve them on edit.
    ids = @skill_session&.activities&.map(&:skill_id) || []
    @session_skills = current_user.skills.where(skillset: active_skillset)
      .or(current_user.skills.where(id: ids)).order(:name)
  end

  def skill_session_params
    params.require(:skill_session).permit(:title, :type, :date, :notes,
      activities_attributes: %i[id reps description rating skill_id _destroy])
  end
end
