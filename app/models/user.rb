class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :skills
  has_many :domains

  after_create :create_domain
  after_create :create_example_skill

  def create_domain
    # d = Domain.new
    d = Domain.create(name: 'BJJ', user_id: self.id)
    u = User.find(id)
    u.current_domain = d.id
    u.save!
  end

  def create_example_skill
    new_domain = User.find(id).domains.first
    s = Skill.create(name: 'Triangle from Closed Guard', notes: "Welcome to Skylz! \rThis is an example of a skill. \rYou can ecit or delete this. And of course, you can change BJJ to whatever 'domain' of skills you want to track!", user_id: self.id, domain_id: new_domain.id, tags: "easy, welcome, task")
    Activity.create(description: "Did 10x reps on each side with my grappling dummy", user_id: self.id, skill_id: s.id, tags: "solo, fun, home", activity_type: "Solo Drills", date: Date.yesterday, rating: 5)
    Activity.create(description: "Managed to pull this off in rolls with the new white belt. He just escaped.", user_id: self.id, skill_id: s.id, tags: "success", activity_type: "Rolls", date: Date.yesterday, rating: 2)
    Activity.create(description: "Saw this move in class for the first time. Almost managed it but forgot the last step", user_id: self.id, skill_id: s.id, tags: "class, first time", activity_type: "Class", date: Date.yesterday, rating: 2)
  end
end
