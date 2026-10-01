class PracticeListsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_skillset
  before_action :set_practice_list, only: %i[show destroy]

  def index
    @practice_lists = current_user.practice_lists.includes(:skillset, practice_items: :skill)
  end

  def show
    @available_skills = current_user.skills.where(skillset: @practice_list.skillset)
      .where.not(id: @practice_list.practice_items.select(:skill_id)).order(:name)
  end

  def new
    @practice_list = current_user.practice_lists.build(skillset: active_skillset)
  end

  def create
    skillset = current_user.skillsets.find(params.dig(:practice_list, :skillsets_id) || active_skillset.id)
    @practice_list = current_user.practice_lists.build(skillset: skillset)
    if @practice_list.save
      redirect_to @practice_list, notice: 'Practice list created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @practice_list.destroy!
    redirect_to practice_lists_path, notice: 'Practice list deleted.'
  end

  private

  def set_practice_list
    @practice_list = current_user.practice_lists.find(params[:id])
  end
end
