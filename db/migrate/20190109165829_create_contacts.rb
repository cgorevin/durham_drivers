class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :type
      t.string :info
      t.references :offense, foreign_key: true

      t.timestamps
    end
  end
end
