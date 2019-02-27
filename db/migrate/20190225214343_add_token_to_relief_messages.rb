class AddTokenToReliefMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :relief_messages, :token, :string
    add_index :relief_messages, :token
  end
end
