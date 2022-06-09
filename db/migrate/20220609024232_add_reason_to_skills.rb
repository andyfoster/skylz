class AddReasonToSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :reason, :text
  end
end
