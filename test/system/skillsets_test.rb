require 'application_system_test_case'

class SkillsetsTest < ApplicationSystemTestCase
  setup do
    @skillset = skillsets(:one)
  end

  test 'visiting the index' do
    visit skillsets_url
    assert_selector 'h1', text: 'Skillsets'
  end

  test 'should create skillset' do
    visit skillsets_url
    click_on 'New skillset'

    fill_in 'User', with: @skillset.user_id
    click_on 'Create Skillset'

    assert_text 'Skillset was successfully created'
    click_on 'Back'
  end

  test 'should update Skillset' do
    visit skillset_url(@skillset)
    click_on 'Edit this skillset', match: :first

    fill_in 'User', with: @skillset.user_id
    click_on 'Update Skillset'

    assert_text 'Skillset was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Skillset' do
    visit skillset_url(@skillset)
    click_on 'Destroy this skillset', match: :first

    assert_text 'Skillset was successfully destroyed'
  end
end
