require 'rails_helper'

RSpec.describe "skill_sessions/new", type: :view do
  before(:each) do
    assign(:skill_session, SkillSession.new())
  end

  it "renders new skill_session form" do
    render

    assert_select "form[action=?][method=?]", skill_sessions_path, "post" do
    end
  end
end
