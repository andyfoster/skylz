# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :skills, dependent: :destroy
  has_many :skillsets, dependent: :destroy
  has_many :practice_lists, dependent: :destroy
  has_many :activities

  before_save :ensure_authentication_token

  after_create :create_skillset
  after_create :create_example_skill

  has_secure_password

  def num_reps_total # seems to be total ever
    activities.where('created_at >= ?', 1.week.ago).sum(:reps)
  end

  def num_reps_this_week
    activities.where('activities.created_at >= ?', Time.zone.now.beginning_of_week).sum(:reps)

    # activities.where('created_at >= ? AND created_at <= ?', 2.week.ago, 1.week.ago).sum(:reps)
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def create_skillset
    d = Skillset.create(name: 'BJJ', user_id: id)
    u = User.find(id)
    u.current_skillset = d.id
    u.save!
  end

  def refresh_token_only
    self.authentication_token = generate_authentication_token
    save!
  end

  # Redirect to user account page after refresh
  def refresh_token
    self.authentication_token = generate_authentication_token
    save!
    # current_user.generate_authentication_token
    redirect_to dashboard_path, notice: 'Token has been refreshed.'
  end

  def create_example_skill
    new_skillset = User.find(id).skillsets.first
    s = Skill.create(name: 'Triangle from Closed Guard',
                     notes: "Welcome to Skylz! \rThis is an example of a skill. \rYou can edit or delete this. And of course, you can change BJJ to whatever 'skillset' of skills you want to track!", user_id: id, skillset_id: new_skillset.id, tags: 'easy, welcome, task')
    Activity.create(description: 'Did 10x reps on each side with my grappling dummy', user_id: id, skill_id: s.id,
                    tags: 'solo, fun, home', activity_type: 'Solo Drills', date: Date.yesterday, rating: 5)
    Activity.create(description: 'Managed to pull this off in rolls with the new white belt.',
                    user_id: id, skill_id: s.id, tags: 'success', activity_type: 'Rolls', date: Date.yesterday, rating: 2)
    Activity.create(
      description: 'Saw this move in class for the first time. Almost managed it but forgot the last step', user_id: id, skill_id: s.id, tags: 'class, first time', activity_type: 'Class', date: Date.yesterday, rating: 2
    )
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
