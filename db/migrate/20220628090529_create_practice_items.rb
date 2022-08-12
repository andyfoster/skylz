class CreatePracticeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_items do |t|
      t.references :skill, null: false, foreign_key: true
      t.belongs_to :practice_list, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
