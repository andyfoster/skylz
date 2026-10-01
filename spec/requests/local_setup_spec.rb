require 'rails_helper'

RSpec.describe 'Local application setup', type: :request do
  it 'registers a user with example data and renders their main pages' do
    get root_path
    expect(response).to have_http_status(:ok)

    post user_registration_path, params: {
      user: {
        email: 'local-setup@example.com',
        password: 'local-password',
        password_confirmation: 'local-password'
      }
    }
    expect(response).to have_http_status(:redirect)

    user = User.find_by!(email: 'local-setup@example.com')
    expect(user.skillsets).to be_present
    expect(user.skills).to be_present

    [root_path, skills_path, dashboard_path].each do |path|
      get path
      expect(response).to have_http_status(:ok), "Expected #{path} to render successfully"
    end
  end
end
