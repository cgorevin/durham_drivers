class AddCaseNumberToOffenses < ActiveRecord::Migration[5.2]
  def change
    remove_column :offenses, :code, :string
    remove_column :offenses, :text, :string
    add_column :offenses, :case_number, :string
    add_column :offenses, :description, :text
  end
end
