require "application_system_test_case"

class PracticeListsTest < ApplicationSystemTestCase
  setup do
    @practice_list = practice_lists(:one)
  end

  test "visiting the index" do
    visit practice_lists_url
    assert_selector "h1", text: "Practice lists"
  end

  test "should create practice list" do
    visit practice_lists_url
    click_on "New practice list"

    click_on "Create Practice list"

    assert_text "Practice list was successfully created"
    click_on "Back"
  end

  test "should update Practice list" do
    visit practice_list_url(@practice_list)
    click_on "Edit this practice list", match: :first

    click_on "Update Practice list"

    assert_text "Practice list was successfully updated"
    click_on "Back"
  end

  test "should destroy Practice list" do
    visit practice_list_url(@practice_list)
    click_on "Destroy this practice list", match: :first

    assert_text "Practice list was successfully destroyed"
  end
end
