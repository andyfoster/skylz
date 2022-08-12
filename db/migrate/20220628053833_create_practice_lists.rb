class CreatePracticeLists < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_lists do |t|
      t.references :domain, null: false, foreign_key: true, index: { unique: true }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
