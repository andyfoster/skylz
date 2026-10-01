require 'rails_helper'

RSpec.describe 'Repaired practice flows', type: :request do
  let!(:user) { User.create!(email: 'repair@example.com', password: 'password123') }
  let!(:other) { User.create!(email: 'other-repair@example.com', password: 'password123') }
  let(:skill) { user.skills.first }

  def login
    post user_session_path, params: { user: { email: user.email, password: 'password123' } }
    expect(response).to have_http_status(:redirect)
  end

  def build_practice_session(owner, owner_skill, notes = 'A private session')
    owner.skill_sessions.create!(date: Date.current, type: 'Practice', notes: notes,
      activities_attributes: [{ skill_id: owner_skill.id, reps: 4, rating: 3 }])
  end

  it 'renders the signed-in screens and supports search' do
    login
    [root_path, skills_path, new_skill_path, new_multi_path, skill_path(skill), edit_skill_path(skill),
     skill_sessions_path, new_skill_session_path, activities_path, dashboard_path,
     skillsets_path, edit_user_registration_path, export_skills_path].each do |path|
      get path
      expect(response).to have_http_status(:ok), "Expected #{path} to render"
    end
    get skills_path, params: { q: 'No matching skill' }
    expect(response.body).to include('No skills to show')
    expect(response.body).not_to include('Triangle from Closed Guard')
    get skills_path, params: { q: 'Triangle', tag: 'welcome', sort: 'name' }
    expect(response.body).to include('Triangle from Closed Guard')
  end

  it 'saves session details and assigns nested activities to the signed-in user' do
    login
    post skill_sessions_path, params: { skill_session: { title: 'Evening practice', type: 'Partner Drills', date: '2026-09-15',
      activities_attributes: { '0' => { skill_id: skill.id, user_id: other.id, date: '2000-01-01', reps: 7, description: 'Useful practice', rating: 4 } } } }
    expect(response).to have_http_status(:redirect)
    session = user.skill_sessions.last
    expect(session.title).to eq('Evening practice')
    expect(session.type).to eq('Partner Drills')
    activity = session.activities.first
    expect(activity.user).to eq(user)
    expect(activity.date).to eq(Date.new(2026, 9, 15))
    expect(activity.activity_type).to eq('Partner Drills')
    get edit_skill_session_path(session)
    expect(response.body).to include('value="7"', 'value="2026-09-15"')
    patch skill_session_path(session), params: { skill_session: { notes: 'Updated', activities_attributes: { '0' => { id: activity.id, reps: 9 } } } }
    expect(response).to have_http_status(:redirect)
    expect(activity.reload.reps).to eq(9)
  end

  it 'removes an existing nested activity and rejects an empty session' do
    login
    session = user.skill_sessions.create!(date: Date.current, activities_attributes: [
      { skill_id: skill.id, reps: 2 }, { skill_id: skill.id, reps: 3 }])
    first, second = session.activities.to_a
    patch skill_session_path(session), params: { skill_session: { activities_attributes: { '0' => { id: first.id, _destroy: '1' } } } }
    expect(response).to have_http_status(:redirect)
    expect(session.activities.reload.pluck(:id)).to eq([second.id])
    patch skill_session_path(session), params: { skill_session: { activities_attributes: { '0' => { id: second.id, _destroy: '1' } } } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(second.reload).to be_persisted
  end

  it 'does not expose or change another account’s records' do
    private_session = build_practice_session(other, other.skills.first, 'Other account private notes')
    login
    get skill_sessions_path
    expect(response.body).not_to include('Other account private notes')
    [skill_session_path(private_session), skill_path(other.skills.first), edit_skillset_path(other.skillsets.first),
     set_skillset_path(other.skillsets.first)].each do |path|
      expect { get path }.to raise_error(ActiveRecord::RecordNotFound)
    end
    expect { patch skill_path(other.skills.first), params: { skill: { name: 'Tampered' } } }.to raise_error(ActiveRecord::RecordNotFound)
    post skill_sessions_path, params: { skill_session: { date: Date.current, activities_attributes: { '0' => { skill_id: other.skills.first.id, reps: 1 } } } }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'preserves activity values when editing and saves standalone activities' do
    login
    activity = skill.activities.first
    get edit_skill_activity_path(skill, activity)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("value=\"#{activity.date}\"")
    post skill_activities_path(skill), params: { activity: { date: Date.current, reps: 6, rating: 4, activity_type: 'Class' } }
    expect(response).to have_http_status(:redirect)
    expect(user.activities.last.reps).to eq(6)
  end

  it 'creates empty skillsets and recovers from a missing selection' do
    login
    post skillsets_path, params: { skillset: { name: 'New area' } }
    expect(response).to have_http_status(:redirect)
    new_set = user.skillsets.last
    expect(new_set.skills.count).to eq(0)
    get root_path
    expect(response.body).to include('No skills to show')
    user.update_column(:current_skillset, 999999)
    get root_path
    expect(response).to have_http_status(:ok)
    expect(user.reload.current_skillset).to eq(user.skillsets.order(:id).first.id)
  end

  it 'creates bulk skills atomically and reports duplicates' do
    login
    post create_multi_path, params: { skill: { name: "One\nTwo", skillset_id: skill.skillset_id, tags: 'bulk' } }
    expect(response).to have_http_status(:redirect)
    expect(user.skills.where(name: ['One', 'Two']).count).to eq(2)
    post create_multi_path, params: { skill: { name: "Three\nOne", skillset_id: skill.skillset_id } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(user.skills.where(name: 'Three')).not_to exist
  end

  it 'requires a password for API login and keeps tokens stable' do
    token = user.authentication_token
    post '/api/v1/auth', params: { email: user.email, password: 'incorrect' }
    expect(response).to have_http_status(:unauthorized)
    post '/api/v1/auth', params: { email: user.email, password: 'password123' }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['api_token']).to eq(token)
    login
    get set_skillset_path(user.skillsets.first)
    expect(user.reload.authentication_token).to eq(token)
    post refresh_token_path
    expect(response).to have_http_status(:redirect)
    expect(user.reload.authentication_token).not_to eq(token)
  end
  it 'supports practice lists without exposing another account’s lists' do
    login
    post practice_lists_path, params: { practice_list: { skillsets_id: skill.skillset_id } }
    expect(response).to have_http_status(:redirect)
    list = user.practice_lists.last
    post practice_items_path, params: { practice_item: { practice_list_id: list.id, skill_id: skill.id } }
    expect(response).to redirect_to(practice_list_path(list))
    item = list.practice_items.last
    get practice_list_path(list)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(skill.name)
    expect { post practice_items_path, params: { practice_item: { practice_list_id: list.id, skill_id: other.skills.first.id } } }.to raise_error(ActiveRecord::RecordNotFound)
    expect(list.practice_items.count).to eq(1)
    delete practice_item_path(item)
    expect(response).to redirect_to(practice_list_path(list))
    expect(list.practice_items.count).to eq(0)
  end

  it 'renders validation errors and handles a missing AI configuration' do
    login
    post skills_path, params: { skill: { name: '', skillset_id: skill.skillset_id } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include('Please check the following')
    post skill_sessions_path, params: { skill_session: { date: '', activities_attributes: { '0' => { skill_id: skill.id, reps: -2 } } } }
    expect(response).to have_http_status(:unprocessable_entity)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return(nil)
    get generate_skills_path, params: { message: 'Test' }
    expect(response).to have_http_status(:service_unavailable)
  end

  it 'parses an AI draft without contacting the API' do
    login
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return('test-placeholder')
    allow(ChatgptService).to receive(:call).and_return('```json\n{"reason":"Example", "note":"Some notes", "steps":["First"], "tags":["tag"]}\n```'.gsub('\\n', "\n"))
    get generate_skills_path, params: { message: 'Test' }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['notes']).to eq('Some notes')
  end

  it 'handles malformed AI fields and incomplete drafts without breaking the form' do
    login
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return('test-placeholder')
    allow(ChatgptService).to receive(:call).and_return('{"reason":"Example","notes":"Notes","steps":"Wrong shape","tags":[]}')
    get generate_skills_path, params: { message: 'Test' }
    expect(response).to have_http_status(:bad_gateway)
    expect(JSON.parse(response.body)['error']).to include('could not be read')
    allow(ChatgptService).to receive(:call).and_raise(ChatgptService::IncompleteDraft)
    get generate_skills_path, params: { message: 'Test' }
    expect(response).to have_http_status(:bad_gateway)
    expect(JSON.parse(response.body)['error']).to include('incomplete')
  end

  it 'counts weekly practice using its date rather than when it was entered' do
    old = user.activities.first
    old.update!(date: Date.current - 14, reps: 99)
    user.activities.create!(skill: skill, date: Date.current, reps: 7, created_at: 1.year.ago)
    login
    get dashboard_path
    expect(response.body).to match(/Reps this week.*?<strong>7<\/strong>/m)
  end

  it 'accepts bearer tokens and rejects another user’s skill through the API' do
    get '/api/v1/skills', headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
    expect(response).to have_http_status(:ok)
    post '/api/v1/activities', params: { skill_id: other.skills.first.id, activity: { date: Date.current, reps: 2 } }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'shows accessible authentication forms and rejects unauthenticated access' do
    [new_user_session_path, new_user_registration_path, new_user_password_path].each do |path|
      get path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('for="user_email"')
    end
    [skills_path, skill_sessions_path, activities_path, practice_lists_path].each do |path|
      get path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
