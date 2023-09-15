require "rails_helper"

RSpec.describe SkillSessionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/skill_sessions").to route_to("skill_sessions#index")
    end

    it "routes to #new" do
      expect(get: "/skill_sessions/new").to route_to("skill_sessions#new")
    end

    it "routes to #show" do
      expect(get: "/skill_sessions/1").to route_to("skill_sessions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/skill_sessions/1/edit").to route_to("skill_sessions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/skill_sessions").to route_to("skill_sessions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/skill_sessions/1").to route_to("skill_sessions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/skill_sessions/1").to route_to("skill_sessions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/skill_sessions/1").to route_to("skill_sessions#destroy", id: "1")
    end
  end
end
