class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_skillset

  def index
    @current_skillset = active_skillset
    @activities = current_user.activities.joins(:skill).where(skills: { skillset_id: @current_skillset.id })
    this_week = @activities.where(date: Date.current.beginning_of_week..Date.current)
    @num_activities = @activities.count
    @num_activities_this_week = this_week.count
    @reps_this_week = this_week.sum(:reps)
    @sessions_this_week = this_week.where.not(skill_session_id: nil).distinct.count(:skill_session_id)
    @total_reps_by_day = @activities.group_by_day(:date).sum(:reps)
    @activities_by_week = @activities.group_by_week(:date).count
    @total_reps_by_week = @activities.group_by_week(:date).sum(:reps)
    @average_rating_by_day = @activities.group_by_day(:date).average(:rating)
    @activity_types_count = @activities.group(:activity_type).count
    names = current_user.skills.where(skillset: @current_skillset).pluck(:id, :name).to_h
    @avg_rating_per_skill = @activities.where.not(rating: nil).group(:skill_id).average(:rating)
      .transform_keys { |id| names.fetch(id) }
  end
end
