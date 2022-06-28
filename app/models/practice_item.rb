class PracticeItem < ApplicationRecord
  belongs_to :skill
  belongs_to :PracticeList
end
