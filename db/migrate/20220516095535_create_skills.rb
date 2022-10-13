class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :icon
      t.string :notes
      t.string :reason
      t.text :steps
      t.string :media
      t.string :tags
      t.string :category
      t.references :user, foreign_key: true, null: false
      t.references :skillset, null: false, foreign_key: true, default: 0

      t.timestamps
    end
  end
end
