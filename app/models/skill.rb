class Skill < ApplicationRecord
  belongs_to :user
  has_one :domain, through: :user
end
