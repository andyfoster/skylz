class AddStepsToSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :steps, :text
  end
end
