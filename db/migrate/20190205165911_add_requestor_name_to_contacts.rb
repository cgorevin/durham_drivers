class AddRequestorNameToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :requestor_name, :string
  end
end
