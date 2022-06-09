# frozen_string_literal: true

class Skill < ApplicationRecord
  belongs_to :user
  has_one :domain
  has_many :activities, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :domain_id, presence: true

  has_rich_text :notes

  def total_reps
    activities.sum(:reps)
  end
end
