require 'rails_helper'

RSpec.describe "skill_sessions/show", type: :view do
  before(:each) do
    assign(:skill_session, SkillSession.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
