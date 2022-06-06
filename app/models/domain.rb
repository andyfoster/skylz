# frozen_string_literal: true

class Domain < ApplicationRecord
  belongs_to :user
  has_many :skills, dependent: :destroy
end
