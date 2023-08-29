module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :authenticate_user_from_token!
      
      def index
        activities = Activity.all
        render json: activities
      end

      # add more methods here
    end
  end
end
