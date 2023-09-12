# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :user_id, presence: true
  validates :date, presence: true
  validates :skill_id, presence: true
  validates :activity_type, presence: true
  validates :rating, presence: true
  validates :reps, presence: true
end
