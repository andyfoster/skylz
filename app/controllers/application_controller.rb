# frozen_string_literal: true

class ApplicationController < ActionController::Base

  # Let my helper methods see the current user
  helper_method :current_user, :active_skillset

  def active_skillset
    return unless current_user
    return @active_skillset if defined?(@active_skillset)

    @active_skillset = current_user.skillsets.find_by(id: current_user.current_skillset) || current_user.skillsets.order(:id).first
    if @active_skillset && current_user.current_skillset != @active_skillset.id
      current_user.update_column(:current_skillset, @active_skillset.id)
    end
    @active_skillset
  end

  def require_skillset
    redirect_to new_skillset_path, notice: 'Create a skillset to get started.' unless active_skillset
  end


  protected

  def authenticate_user_from_token!
    auth_token = request.headers['Authorization'].to_s.sub(/\ABearer\s+/i, '').strip

    if auth_token.present?
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
