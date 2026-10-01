# frozen_string_literal: true

class PracticeItem < ApplicationRecord
  belongs_to :skill
  belongs_to :practice_list

  validate :skill_matches_list

  def skill_matches_list
    if skill && practice_list && (skill.user_id != practice_list.user_id || skill.skillset_id != practice_list.skillsets_id)
      errors.add(:skill, 'must belong to this list’s skillset')
    end
  end

  validates :skill_id, uniqueness: { scope: :practice_list_id, message: 'Skill is already in list' }
end
