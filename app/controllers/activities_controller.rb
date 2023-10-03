# frozen_string_literal: true

class ActivitiesController < ApplicationController
  before_action :get_skill, except: %i[index]
  before_action :set_activity, only: %i[show edit update destroy]
  before_action :authenticate_user!

  before_action :current_skillset

  # GET /activities or /activities.json

  def index
    @skillset = Skillset.find(current_user.current_skillset)
    user_skill_ids = Skill.where(skillset_id: @skillset).pluck('id')
    @activities = Activity.where(skill_id: user_skill_ids).includes ([:skill])
    @activities = @activities.sort_by(&:date)
  end

  # GET /skills/:skill_id/activities/1 or /activities/1.json
  def show
    @activity = @skill.activities.find(params[:id])
  end

  # GET /activities/new
  def new
    @last_activity_type = if @skill.activities.empty?
                            'Solo Practice'
                          else
                            @skill.activities.last.activity_type
                          end
    @activity = @skill.activities.build
  end

  def show_all
    # @activities = current_user.activities.where(condition) current_user.current_skillset
  end

  # GET /activities/1/edit
  def edit; end

  # POST /activities or /activities.json
  def create
    @activity = @skill.activities.build(activity_params)

    # @skill = @skill = current_user.skills.build(skill_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to skill_path(@skill) }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to skill_path(@skill) }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to skill_path(@skill) }
      format.json { head :no_content }
    end
  end

  private

  def get_skill
    @skill = Skill.find(params[:skill_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = @skill.activities.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def activity_params
    params.require(:activity)
          .permit(:description, :skill_id, :date, :tags, :rating, :activity_type,
                  :reps).merge({ user_id: current_user.id })
  end

  def current_skillset
    @current_skillset = current_user.current_skillset
  end
end
