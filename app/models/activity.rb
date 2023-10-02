# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :skill # todo: remove?
  belongs_to :skill_session

  validates :user_id, presence: true
  # validates :date, presence: true
  validates :skill_id, presence: true
  # validates :activity_type, presence: true
  # validates :rating, presence: true
  validates :reps, presence: true


   def skillset_id
      skill.skillset_id
    end
end
