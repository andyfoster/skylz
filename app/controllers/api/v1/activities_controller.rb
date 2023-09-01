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
        if params[:skill_id].nil?
          render json: { errors: "Skill ID is required" }, status: :unprocessable_entity
          return
        elsif Skill.find(params[:skill_id]).nil?
          render json: { errors: "Skill ID is invalid (skill not found)" }, status: :unprocessable_entity
          return
        elsif Skill.find(params[:skill_id]).user_id != current_user.id
          render json: { errors: "Skill ID is invalid (not your skill)" }, status: :unprocessable_entity
          return
        end

        skill = Skill.find(params[:skill_id])
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
              .permit(:description, :skill_id, :date, :tags, :rating, :activity_type,
                      :reps).merge({ user_id: current_user.id })
      end
    end
  end
end
