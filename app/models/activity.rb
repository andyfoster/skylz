# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :skill # todo: remove?
  belongs_to :skill_session, optional: true

  validates :user_id, presence: true
  # validates :date, presence: true
  validates :skill_id, presence: true
  # validates :activity_type, presence: true
  # validates :rating, presence: true
  validates :reps, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true
  validates :date, presence: true
  validate :skill_belongs_to_user

  def skill_belongs_to_user
    errors.add(:skill, 'must belong to your account') if skill && user_id != skill.user_id
  end


   def skillset_id
      skill.skillset_id
    end
end
