class Domain < ApplicationRecord
  belongs_to :user
  has_many :skills, dependent: :destroy
end
