class AddCurrentDomainToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :domain, foreign_key: true
  end
end
