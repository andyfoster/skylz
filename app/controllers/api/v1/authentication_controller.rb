module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :verify_authenticity_token

      def login
        user = User.find_by(email: params[:email].to_s.downcase)
        if user && user.valid_password?(params[:password].to_s)
          render json: { api_token: user.authentication_token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
