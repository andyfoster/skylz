class PracticeList < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  has_many :practice_items, dependent: :destroy

  validates :domain_id, uniqueness: true, presence: true, numericality: { only_integer: true }
end
