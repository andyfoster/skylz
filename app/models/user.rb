# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :skills, dependent: :destroy
  has_many :skillsets, dependent: :destroy
  has_many :practice_lists, dependent: :destroy

  after_create :create_skillset
  after_create :create_example_skill

  def create_skillset
    d = Skillset.create(name: 'BJJ', user_id: id)
    u = User.find(id)
    u.current_skillset = d.id
    u.save!
  end

  def create_example_skill
    new_skillset = User.find(id).skillsets.first
    s = Skill.create(name: 'Triangle from Closed Guard',
                     notes: "Welcome to Skylz! \rThis is an example of a skill. \rYou can edit or delete this. And of course, you can change BJJ to whatever 'skillset' of skills you want to track!", user_id: id, skillset_id: new_skillset.id, tags: 'easy, welcome, task')
    Activity.create(description: 'Did 10x reps on each side with my grappling dummy', user_id: id, skill_id: s.id,
                    tags: 'solo, fun, home', activity_type: 'Solo Drills', date: Date.yesterday, rating: 5)
    Activity.create(description: 'Managed to pull this off in rolls with the new white belt. He just escaped.',
                    user_id: id, skill_id: s.id, tags: 'success', activity_type: 'Rolls', date: Date.yesterday, rating: 2)
    Activity.create(
      description: 'Saw this move in class for the first time. Almost managed it but forgot the last step', user_id: id, skill_id: s.id, tags: 'class, first time', activity_type: 'Class', date: Date.yesterday, rating: 2
    )
  end
end
