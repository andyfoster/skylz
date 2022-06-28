require "test_helper"

class PracticeListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @practice_list = practice_lists(:one)
  end

  test "should get index" do
    get practice_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_practice_list_url
    assert_response :success
  end

  test "should create practice_list" do
    assert_difference("PracticeList.count") do
      post practice_lists_url, params: { practice_list: {  } }
    end

    assert_redirected_to practice_list_url(PracticeList.last)
  end

  test "should show practice_list" do
    get practice_list_url(@practice_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_practice_list_url(@practice_list)
    assert_response :success
  end

  test "should update practice_list" do
    patch practice_list_url(@practice_list), params: { practice_list: {  } }
    assert_redirected_to practice_list_url(@practice_list)
  end

  test "should destroy practice_list" do
    assert_difference("PracticeList.count", -1) do
      delete practice_list_url(@practice_list)
    end

    assert_redirected_to practice_lists_url
  end
end
