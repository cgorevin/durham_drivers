class AddColumnsToOffenses < ActiveRecord::Migration[5.2]
  def change
    add_column :offenses, :street_address, :string
    add_column :offenses, :city, :string
  end
end
