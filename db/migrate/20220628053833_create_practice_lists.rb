class CreatePracticeLists < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_lists do |t|
      t.references :domain
      t.references :user

      t.timestamps
    end
  end
end
