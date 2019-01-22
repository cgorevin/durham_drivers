class AddContactOffensesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts_offenses do |t|
      t.references :contact, foreign_key: true
      t.references :offense, foreign_key: true
    end

    remove_column :contacts, :offense_id, :integer
  end
end
