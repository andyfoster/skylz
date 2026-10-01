class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :require_skillset

  def index
    @skillset = active_skillset
    @skills = current_user.skills.where(skillset: @skillset).includes(:activities).order(:name)
    @activities = current_user.activities.joins(:skill).where(skills: { skillset_id: @skillset.id })
    @num_activities_this_week = @activities.where(date: Date.current.beginning_of_week..Date.current).count
    @reps_this_week = @activities.where(date: Date.current.beginning_of_week..Date.current).sum(:reps)
    @num_skills = @skills.size
    @num_activities = @activities.count
    names = @skills.index_by(&:id)
    @avg_rating_per_skill = @activities.where.not(rating: nil).group(:skill_id).average(:rating)
      .transform_keys { |id| names.fetch(id).name }
  end
end
