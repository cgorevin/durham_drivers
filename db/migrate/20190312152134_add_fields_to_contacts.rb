class AddFieldsToContacts < ActiveRecord::Migration[5.2]
  change_table :contacts do |t|
    # split info into email and phone
    t.remove :info
    t.string :email
    t.string :phone

    # add ability to save name
    t.string :full_name

    # instead of having 1 method of contact, add ability to have 2
    t.string :advice_method
    t.rename :method, :relief_method

    # add ability to place contact in queue
    t.date :queue_date
  end
end
