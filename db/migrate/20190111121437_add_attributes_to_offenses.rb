class AddAttributesToOffenses < ActiveRecord::Migration[5.2]
  def change
    add_column :offenses, :race, :string
    add_column :offenses, :sex, :string
    add_column :offenses, :code, :string
    add_column :offenses, :text, :string
  end
end
