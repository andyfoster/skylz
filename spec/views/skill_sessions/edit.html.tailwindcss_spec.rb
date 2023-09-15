require 'rails_helper'

RSpec.describe "skill_sessions/edit", type: :view do
  let(:skill_session) {
    SkillSession.create!()
  }

  before(:each) do
    assign(:skill_session, skill_session)
  end

  it "renders the edit skill_session form" do
    render

    assert_select "form[action=?][method=?]", skill_session_path(skill_session), "post" do
    end
  end
end
