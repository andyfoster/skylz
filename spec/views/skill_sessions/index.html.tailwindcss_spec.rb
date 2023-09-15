require 'rails_helper'

RSpec.describe "skill_sessions/index", type: :view do
  before(:each) do
    assign(:skill_sessions, [
      SkillSession.create!(),
      SkillSession.create!()
    ])
  end

  it "renders a list of skill_sessions" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
