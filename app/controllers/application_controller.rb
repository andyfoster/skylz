# frozen_string_literal: true

class ApplicationController < ActionController::Base

  # Let my helper methods see the current user
  helper_method :current_user


  protected

  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authenticate_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    user = User.where(authentication_token: auth_token).first

    if user
      sign_in user, store: false
    else
      authenticate_error
    end
  end

  def authenticate_error
    render json: { error: 'Authentication Error' }, status: 401
  end

end
