# frozen_string_literal: true

class Skill < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  has_many :activities, dependent: :destroy
  has_many :practice_items

  before_destroy :ensure_not_referenced_by_any_practice_item

  # validates [:user_id, :domain_id, :name], presence: true, uniqueness: true
  validates :name, presence: true
  validates :user_id, presence: true
  validates :domain_id, presence: true

  has_rich_text :notes

  def total_reps
    activities.sum(:reps)
  end

  private

  # ensure that there are no practice items referencing this skill
  def ensure_not_referenced_by_any_practice_item
    unless practice_items.empty?
      errors.add(:base, 'Practice items present')
      throw :abort
    end
  end
end
