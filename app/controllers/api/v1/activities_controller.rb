module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :authenticate_user_from_token!

      def index
        activities = current_user.activities
        render json: activities.as_json(except: [:user_id, :created_at, :updated_at])
      end

    end
  end
end
