# frozen_string_literal: true

class PracticeList < ApplicationRecord
  belongs_to :user
  belongs_to :skillset
  has_many :practice_items, dependent: :destroy

  validates :skillset_id, uniqueness: true, presence: true, numericality: { only_integer: true }
end
