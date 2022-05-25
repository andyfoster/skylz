class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :skills
  has_many :domains

  after_create :create_domain
  after_create :create_example_skill

  def create_domain
    # d = Domain.new
    d = Domain.create(name: 'Your Skills', user_id: self.id)
    u = User.find(id)
    u.current_domain = d.id
    u.save!
  end

  def create_example_skill
    new_domain = User.find(id).domains.first
    s = Skill.create(name: 'Triangle Choke from Closed Guard', user_id: self.id, domain_id: new_domain.id, tags: "basic, choke, triangle")
    Activity.create(description: 'Goes here', user_id: self.id, skill_id: s.id, tags: "amazing, easy, fun", activity_type: "practice", date: Date.yesterday, rating: 5)
  end
end
