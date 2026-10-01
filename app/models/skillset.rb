# frozen_string_literal: true

class Skillset < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_one :practice_list, foreign_key: :skillsets_id, dependent: :destroy
  has_many :skills, dependent: :destroy
end
