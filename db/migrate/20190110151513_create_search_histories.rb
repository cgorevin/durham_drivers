class CreateSearchHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :search_histories do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :date_of_birth
      t.string :ip_address

      t.timestamps
    end
  end
end
