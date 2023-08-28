module Api
  module V1
    class ActivitiesController < ApplicationController
      def index
        activities = Activity.all
        render json: activities
      end

      # add more methods here
    end
  end
end
