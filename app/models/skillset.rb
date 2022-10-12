# frozen_string_literal: true

class Skillset < ApplicationRecord
  belongs_to :user
  has_many :skills, dependent: :destroy
  has_one :practice_list, dependent: :destroy
end
