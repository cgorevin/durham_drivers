class CreateContactHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_histories do |t|
      t.references :contact, foreign_key: true
      t.references :offense, foreign_key: true
      t.references :relief_message, foreign_key: true

      t.timestamps
    end
  end
end
