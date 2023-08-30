module Api
  module V1
    class SkillsController < ApplicationController
      before_action :authenticate_user_from_token!

      def index
        skills = current_user.skills
        render json: skills.as_json(except: [:user_id, :created_at, :updated_at])
      end

    end
  end
end