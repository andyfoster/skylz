class DashboardController < ApplicationController
  def index
    # Replace with your actual logic for determining the current user and skillset
    @current_user = current_user
    @current_skillset = Skillset.find(current_user.current_skillset)

    # Fetch activities confined to the current skillset
    @activities = Activity.joins(:skill)
                          .where(user: @current_user, skills: { skillset: @current_skillset })

    # Total reps for each day
    @total_reps_by_day = @activities.group_by_day(:created_at).sum(:reps)

    # Number of activities in a week
    @activities_by_week = @activities.group_by_week(:created_at).count

    @total_reps_by_week = Activity.joins(:skill)
                                  .where(user_id: current_user.id, skills: { skillset: @current_skillset })
                                  .group_by_week(:date).sum(:reps)

    @average_rating_by_day = Activity.joins(:skill)
                                     .where(user_id: current_user.id, skills: { skillset: @current_skillset })
                                     .group_by_day(:date).average(:rating)

    @activity_types_count = Activity.joins(:skill)
                                    .where(user_id: current_user.id, skills: { skillset: @current_skillset })
                                    .group(:activity_type).count

    # Fetch the skills related to the current skillset
    skill_ids = Skill.where(skillset: @current_skillset, user_id: current_user).pluck(:id)

    # Calculate average rating per skill
    @avg_rating_per_skill = Activity.where(skill_id: skill_ids)
                                    .where.not(rating: nil)
                                    .group(:skill_id)
                                    .average(:rating)

    # Convert skill IDs to skill names for better chart readability
    @avg_rating_per_skill = @avg_rating_per_skill.transform_keys { |key| Skill.find(key).name }

  end
end
