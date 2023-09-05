module Api
  module V1
    class SkillsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user_from_token!


      def index
        skills = current_user.skills
        skillset_id = params[:skillset_id]
        # render json: skills.as_json(except: [:user_id, :created_at, :updated_at])#.where(skillset_id: skillset_id)
        render json: skills.where(skillset_id: current_user.current_skillset).as_json(except: [:user_id, :created_at, :updated_at])
      end

      def create
        skill = current_user.skills.build(skill_params)
        if skill.save
          render json: skill.as_json(except: [:user_id, :created_at, :updated_at]), status: :created
        else
          render json: { errors: skill.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def skill_params
        params.fetch(:skill, {}).permit(:name, :notes, :media, :tags, :steps, :category,
                                        :skillset_id, :reason).merge(user_id: current_user.id)
      end

    end
  end
end
