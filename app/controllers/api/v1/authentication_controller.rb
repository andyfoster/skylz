module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :verify_authenticity_token # skip CSRF check for API

      def login
        user = User.find_by(email: params[:email])

        if user.authenticate(params[:password])
          user.generate_authentication_token!
          render json: { api_token: user.authentication_token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
