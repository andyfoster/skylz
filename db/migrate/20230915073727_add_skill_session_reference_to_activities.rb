class AddSkillSessionReferenceToActivities < ActiveRecord::Migration[7.0]
  def change
        # took out requirement for null: false because it breaks with current database values
    add_reference :activities, :skill_session, foreign_key: true
  end
end
