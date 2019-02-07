class AddAmountToOffenses < ActiveRecord::Migration[5.2]
  def change
    add_column :offenses, :relief_amount, :integer
  end
end
