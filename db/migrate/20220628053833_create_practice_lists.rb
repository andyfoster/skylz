class CreatePracticeLists < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_lists do |t|

      t.timestamps
    end
  end
end
