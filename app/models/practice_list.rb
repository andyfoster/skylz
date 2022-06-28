class PracticeList < ApplicationRecord
  belongs_to :user
  has_many :practice_items, dependent: :destroy
end
