class CreateReliefMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :relief_messages do |t|
      t.references :contact, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
