class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :skill
  
  validates :user_id, presence: true
  validates :description, presence: true
end
