class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :notes
      t.string :media
      t.string :tags
      t.string :category

      t.timestamps
    end
  end
end
