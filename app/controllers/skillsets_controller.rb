# frozen_string_literal: true

class SkillsetsController < ApplicationController
  before_action :set_skillset, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /skillsets or /skillsets.json
  def index
    @skillsets = current_user.skillsets
  end

  # GET /skillsets/1 or /skillsets/1.json
  def show; end

  # GET /skillsets/new
  def new
    @skillset = Skillset.new
  end

  # GET /skillsets/1/edit
  def edit; end

  # POST /skillsets or /skillsets.json
  def create
    @skillset = Skillset.new(skillset_params)
    c = current_user

    respond_to do |format|
      if @skillset.save
        c.update_attribute(:current_skillset, @skillset.id)
        # PracticeList.create(skillset_id: @skillset.id, user_id: c.id)

        # Make an example skill to get started
        Skill.create(name: "First Skill",
                     user_id: c.id,
                     skillset_id: @skillset.id,
                     tags: "first, easy",
                     notes: "This is your ==first== skill. You can **edit** or _delete_ it.",
                     reason: "When you might do this skill, e.g. after finishing a spin",
                     steps: "Step one\nStep two")
        c.save!

        # Make an example activity to get started
        newSkillSession = SkillSession.create(user_id: c.id, title: "First Skill Session", date: Date.today)

        a = Activity.create(user_id: c.id,
                            description: "Each time you practice a skill, add an activity here. You can add a rating, notes, and tags to help you remember what you did.",
                            skill_id: Skill.last.id,
                            reps: 4,
                            skill_session_id: newSkillSession.id,
                            activity_type: "practice",
                            rating: 3,
                            date: Date.today)
        a.save!

        format.html { redirect_to root_path, notice: "Skillset was successfully created." }
        format.json { render :show, status: :created, location: @skillset }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skillset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skillsets/1 or /skillsets/1.json
  def update
    respond_to do |format|
      if @skillset.update(skillset_params)
        format.html { redirect_to skillsets_path, notice: "Skillset was successfully updated." }
        format.json { render :show, status: :ok, location: @skillset }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skillset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skillsets/1 or /skillsets/1.json
  def destroy
    @skillset.destroy

    respond_to do |format|
      format.html { redirect_to skillsets_url, notice: "Skillset was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_current
    c = current_user
    c.update_attribute(:current_skillset, params[:id])
    c.save!

    redirect_to root_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skillset
    @skillset = Skillset.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skillset_params
    params.require(:skillset).permit(:name).merge({ user_id: current_user.id })
  end
end
