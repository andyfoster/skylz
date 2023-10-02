class SkillSession < ApplicationRecord
  has_many :activities, dependent: :destroy
  accepts_nested_attributes_for :activities, allow_destroy: true
end
