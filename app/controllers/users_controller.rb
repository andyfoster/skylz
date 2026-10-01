class UsersController < ApplicationController
  before_action :authenticate_user!

  def refresh_token
    current_user.refresh_token_only
    redirect_to edit_user_registration_path, notice: 'API token refreshed.'
  end
end
