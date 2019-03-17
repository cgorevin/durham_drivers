class AddBoleanToReliefMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :relief_messages, :new, :boolean, default: true
  end
end
