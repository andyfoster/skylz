class SkillSession < ApplicationRecord
  # The legacy type column stores the activity category, not a Ruby subclass.
  self.inheritance_column = :_type_disabled

  belongs_to :user
  has_many :activities, dependent: :destroy, inverse_of: :skill_session
  accepts_nested_attributes_for :activities, allow_destroy: true
  validates :date, presence: true
  validate :has_activities
  before_validation :assign_activity_details

  private

  def assign_activity_details
    activities.each do |activity|
      next if activity.marked_for_destruction?
      activity.user = user
      activity.date = date
      activity.activity_type = type if type.present?
    end
  end

  def has_activities
    errors.add(:base, 'Add at least one activity to the session.') if activities.reject(&:marked_for_destruction?).empty?
  end
end
