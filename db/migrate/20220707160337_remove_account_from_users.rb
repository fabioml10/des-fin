class RemoveAccountFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :users, :account, null: false, foreign_key: true
  end
end
