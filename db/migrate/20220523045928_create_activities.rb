class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.string :activity_type
      t.date :date
      t.integer :rating
      t.string :tags

      t.timestamps
    end
  end
end
