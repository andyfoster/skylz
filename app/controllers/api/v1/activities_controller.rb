module Api
  module V1
    class ActivitiesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user_from_token!

      def index
        activities = current_user.activities
        render json: activities.as_json(except: [:user_id, :created_at, :updated_at])
      end

      #   POST to create a new activity
      def create
        skill = current_user.skills.find_by(id: params[:skill_id])
        unless skill
          return render json: { errors: 'Choose one of your skills.' }, status: :unprocessable_entity
        end

        activity = skill.activities.build(activity_params)

        if activity.save
          render json: activity.as_json(except: [:user_id, :created_at, :updated_at]), status: :created
        else
          render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Only allow a list of trusted parameters through.
      def activity_params
        params.require(:activity)
              .permit(:description, :date, :tags, :rating, :activity_type,
                      :reps).merge({ user_id: current_user.id })
      end
    end
  end
end
