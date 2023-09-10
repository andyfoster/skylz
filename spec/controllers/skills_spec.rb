require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  let(:user) { create(:user) }
  let(:skill) { create(:skill, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

#   describe 'GET #show' do
#     it 'returns a success response' do
#       get :show, params: { id: skill.id }
#       expect(response).to be_successful
#     end
#   end

#   describe 'POST #create' do
#     context 'with valid parameters' do
#       it 'creates a new Skill' do
#         expect {
#           post :create, params: { skill: attributes_for(:skill) }
#         }.to change(Skill, :count).by(1)
#       end
#     end

#     context 'with invalid parameters' do
#       it 'does not create a new Skill' do
#         expect {
#           post :create, params: { skill: attributes_for(:skill, :invalid) }
#         }.to change(Skill, :count).by(0)
#       end
#     end
#   end

#   describe 'PUT #update' do
#     context 'with valid parameters' do
#       let(:new_attributes) { attributes_for(:skill) }

#       it 'updates the requested skill' do
#         put :update, params: { id: skill.id, skill: new_attributes }
#         skill.reload
#         expect(skill.attributes).to include(new_attributes)
#       end
#     end

#     context 'with invalid parameters' do
#       it 'does not update the skill' do
#         put :update, params: { id: skill.id, skill: attributes_for(:skill, :invalid) }
#         skill.reload
#         expect(skill.attributes).not_to include(attributes_for(:skill, :invalid))
#       end
#     end
#   end

#   describe 'DELETE #destroy' do
#     it 'destroys the requested skill' do
#       skill = Skill.create! valid_attributes
#       expect {
#         delete :destroy, params: { id: skill.id }
#       }.to change(Skill, :count).by(-1)
#     end
#   end
end