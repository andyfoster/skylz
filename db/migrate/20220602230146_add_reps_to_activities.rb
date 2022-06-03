class AddRepsToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :reps, :integer, :column_options => { :null => false, :default => 1 }
  end
end
