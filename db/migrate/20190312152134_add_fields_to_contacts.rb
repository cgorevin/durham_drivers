class AddFieldsToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :full_name, :string
    add_column :contacts, :letter_contact_method, :string
    add_column :contacts, :queue_date, :date
  end
end
