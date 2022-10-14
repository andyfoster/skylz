# frozen_string_literal: true

require 'application_system_test_case'

class PracticeItemsTest < ApplicationSystemTestCase
  setup do
    @practice_item = practice_items(:one)
  end

  test 'visiting the index' do
    visit practice_items_url
    assert_selector 'h1', text: 'Practice items'
  end

  test 'should create practice item' do
    visit practice_items_url
    click_on 'New practice item'

    fill_in 'Practicelist', with: @practice_item.PracticeList_id
    fill_in 'Skill', with: @practice_item.skill_id
    click_on 'Create Practice item'

    assert_text 'Practice item was successfully created'
    click_on 'Back'
  end

  test 'should update Practice item' do
    visit practice_item_url(@practice_item)
    click_on 'Edit this practice item', match: :first

    fill_in 'Practicelist', with: @practice_item.PracticeList_id
    fill_in 'Skill', with: @practice_item.skill_id
    click_on 'Update Practice item'

    assert_text 'Practice item was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Practice item' do
    visit practice_item_url(@practice_item)
    click_on 'Destroy this practice item', match: :first

    assert_text 'Practice item was successfully destroyed'
  end
end
