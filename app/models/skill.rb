# frozen_string_literal: true

class Skill < ApplicationRecord
  belongs_to :user
  belongs_to :skillset
  has_many :activities, dependent: :destroy
  has_many :practice_items

  before_destroy :ensure_not_referenced_by_any_practice_item

  # validates :name, presence: true
  validates :name, presence: true, uniqueness: { scope: %i[user skillset] }
  validates :user_id, presence: true
  validates :skillset_id, presence: true

  def total_reps
    activities.loaded? ? activities.sum { |activity| activity.reps.to_i } : activities.sum(:reps)
  end

  validate :skillset_belongs_to_user

  def skillset_belongs_to_user
    errors.add(:skillset, 'must belong to your account') if skillset && user_id != skillset.user_id
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
