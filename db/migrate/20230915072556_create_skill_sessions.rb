class CreateSkillSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_sessions do |t|
      t.string :title
      t.datetime :date
      t.text :notes
      t.string :type
      t.string :tags
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
