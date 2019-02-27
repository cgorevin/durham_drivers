class RemoveOffenseIdFromContactHistories < ActiveRecord::Migration[5.2]
  def change
    remove_column :contact_histories, :offense_id, :integer
  end
end
