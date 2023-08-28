module Api
  module V1
    class SkillsController < ApplicationController
      def index
        skills = Skill.all
        render json: skills
      end
      
    end
  end
end