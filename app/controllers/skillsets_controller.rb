# frozen_string_literal: true

class SkillsetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skillset, only: %i[show edit update destroy]

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
    @skillset = current_user.skillsets.build(skillset_params)
    if @skillset.save
      current_user.update_column(:current_skillset, @skillset.id)
      redirect_to root_path, notice: 'Skillset created. Add your first skill.'
    else
      render :new, status: :unprocessable_entity
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
    skillset = current_user.skillsets.find(params[:id])
    current_user.update_column(:current_skillset, skillset.id)
    redirect_to root_path, notice: "Switched to #{skillset.name}."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skillset
    @skillset = current_user.skillsets.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skillset_params
    params.require(:skillset).permit(:name).merge({ user_id: current_user.id })
  end
end
