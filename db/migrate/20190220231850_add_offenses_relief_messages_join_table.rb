class AddOffensesReliefMessagesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :offenses_relief_messages do |t|
      t.references :offense, foreign_key: true
      t.references :relief_message, foreign_key: true
    end
  end
end
