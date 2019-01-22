class RenameContactType < ActiveRecord::Migration[5.2]
  def change
    change_table :contacts do |t|
      t.rename :type, :method
    end
  end

end
