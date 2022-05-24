class Skill < ApplicationRecord
  belongs_to :user
  has_one :domain
  has_many :activities, dependent: :destroy
  validates :name, presence: true
end
