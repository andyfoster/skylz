class CreatePracticeLists < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_lists do |t|
      t.references :skillset, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      # this isn't being remigrated properly - causes problem with skillset/s on user destroy
      t.timestamps
    end
  end
end
