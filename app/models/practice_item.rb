# frozen_string_literal: true

class PracticeItem < ApplicationRecord
  belongs_to :skill
  belongs_to :practice_list

  validates :skill_id, uniqueness: { message: 'Skill is already in list' }
end
