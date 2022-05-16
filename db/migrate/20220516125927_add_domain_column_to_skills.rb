class AddDomainColumnToSkills < ActiveRecord::Migration[7.0]
  def change
    add_reference :skills, :domain, null: false, foreign_key: true, default: 1
  end
end
