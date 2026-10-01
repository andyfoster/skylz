class PracticeItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    list = current_user.practice_lists.find(params.dig(:practice_item, :practice_list_id))
    skill = current_user.skills.where(skillset: list.skillset).find(params.dig(:practice_item, :skill_id))
    item = list.practice_items.build(skill: skill)
    if item.save
      redirect_to list, notice: 'Skill added to practice list.'
    else
      redirect_to list, alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = PracticeItem.joins(:practice_list).where(practice_lists: { user_id: current_user.id }).find(params[:id])
    list = item.practice_list
    item.destroy!
    redirect_to list, notice: 'Skill removed from practice list.'
  end
end
