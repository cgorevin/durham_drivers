class AddIndexesToOffenses < ActiveRecord::Migration[5.2]
  def change
    # add_index :offenses, :first_name
    # add_index :offenses, :middle_name
    # add_index :offenses, :last_name
    add_index :offenses, [:first_name, :middle_name, :last_name]
    add_index :offenses, :date_of_birth # 54.89% faster
    add_index :offenses, :group # 13.57% faster
    # both indexes at once: 63.29% faster
    # add_index :offenses, :status
  end
end
