module Api
  module V1
    class SkillsetsController < ApplicationController
      before_action :authenticate_user_from_token!

      def index
        skillsets = current_user.skillsets
        current_skillset = current_user.current_skillset
        # add is_current attribute to skillsets
        render json: skillsets.as_json(except: [:user_id, :created_at, :updated_at]).map { |skillset|
          skillset[:is_current] = skillset["id"] == current_skillset
          skillset
        }
      end

    end
  end
end