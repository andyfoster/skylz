require 'test_helper'

class SkillsetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skillset = skillsets(:one)
  end

  test 'should get index' do
    get skillsets_url
    assert_response :success
  end

  test 'should get new' do
    get new_skillset_url
    assert_response :success
  end

  test 'should create skillset' do
    assert_difference('Skillset.count') do
      post skillsets_url, params: { skillset: { user_id: @skillset.user_id } }
    end

    assert_redirected_to skillset_url(Skillset.last)
  end

  test 'should show skillset' do
    get skillset_url(@skillset)
    assert_response :success
  end

  test 'should get edit' do
    get edit_skillset_url(@skillset)
    assert_response :success
  end

  test 'should update skillset' do
    patch skillset_url(@skillset), params: { skillset: { user_id: @skillset.user_id } }
    assert_redirected_to skillset_url(@skillset)
  end

  test 'should destroy skillset' do
    assert_difference('Skillset.count', -1) do
      delete skillset_url(@skillset)
    end

    assert_redirected_to skillsets_url
  end
end
