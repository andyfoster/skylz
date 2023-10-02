class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :get_current_skillset


def index
  @skillset = Skillset.find(current_user.current_skillset)
  # @activities = current_user.activities.where(skillset_id: current_user.current_skillset)
  @activities = current_user.activities


  # activiies have skills and skills have skillset ids
  # how can I access skillset Id through the activity's skill?
  # @activities.skillset_id

  @activities_for_current_skillset = current_user.activities.where(skillset_id: current_user.current_skillset).includes(:skill)
  # @activities_for_current_skillset = current_user.activities.where(skillset_id: current_user.current_skillset).includes(:skill)

  @skills = current_user.skills.where(skillset_id: current_user.current_skillset).includes(:activities)

  # @num_activities_this_week = .where('created_at >= ?', 1.week.ago).count
  @num_activities_this_week = @activities.where('created_at >= ?', 1.week.ago).count

  @num_skills = @skills.where(skillset_id: current_user.current_skillset).count

    # Fetch the skills related to the current skillset
    skill_ids = Skill.where(skillset: @current_skillset, user_id: current_user).pluck(:id)


  @avg_rating_per_skill = Activity.where(skill_id: skill_ids)
                                    .where.not(rating: nil)
                                    .group(:skill_id)
                                    .average(:rating)

    # Convert skill IDs to skill names for better chart readability
    @avg_rating_per_skill = @avg_rating_per_skill.transform_keys { |key| Skill.find(key).name }

end

  private

  def get_current_skillset
    @current_skillset = Skillset.find(current_user.current_skillset)
  end

end
