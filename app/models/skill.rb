class Skill < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
