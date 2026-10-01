# frozen_string_literal: true

class PracticeList < ApplicationRecord
  belongs_to :user
  belongs_to :skillset, foreign_key: :skillsets_id
  has_many :practice_items, dependent: :destroy

  validate :skillset_belongs_to_user

  def skillset_belongs_to_user
    errors.add(:skillset, 'must belong to your account') if skillset && user_id != skillset.user_id
  end

  validates :skillsets_id, uniqueness: true, presence: true, numericality: { only_integer: true }
end
