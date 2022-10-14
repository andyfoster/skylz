# frozen_string_literal: true

require 'test_helper'

class PracticeItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @practice_item = practice_items(:one)
  end

  test 'should get index' do
    get practice_items_url
    assert_response :success
  end

  test 'should get new' do
    get new_practice_item_url
    assert_response :success
  end

  test 'should create practice_item' do
    assert_difference('PracticeItem.count') do
      post practice_items_url,
           params: { practice_item: { PracticeList_id: @practice_item.PracticeList_id,
                                      skill_id: @practice_item.skill_id } }
    end

    assert_redirected_to practice_item_url(PracticeItem.last)
  end

  test 'should show practice_item' do
    get practice_item_url(@practice_item)
    assert_response :success
  end

  test 'should get edit' do
    get edit_practice_item_url(@practice_item)
    assert_response :success
  end

  test 'should update practice_item' do
    patch practice_item_url(@practice_item),
          params: { practice_item: { PracticeList_id: @practice_item.PracticeList_id,
                                     skill_id: @practice_item.skill_id } }
    assert_redirected_to practice_item_url(@practice_item)
  end

  test 'should destroy practice_item' do
    assert_difference('PracticeItem.count', -1) do
      delete practice_item_url(@practice_item)
    end

    assert_redirected_to practice_items_url
  end
end
