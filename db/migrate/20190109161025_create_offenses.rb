class CreateOffenses < ActiveRecord::Migration[5.2]
  def change
    create_table :offenses do |t|
      t.boolean :type
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :date_of_birth
      t.date :disposition_date
      t.string :status
      t.string :group

      t.timestamps
    end
  end
end
