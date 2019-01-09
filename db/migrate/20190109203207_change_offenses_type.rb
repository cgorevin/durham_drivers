class ChangeOffensesType < ActiveRecord::Migration[5.2]
  def change
    change_table :offenses do |t|
      t.rename :type, :ftp
    end
  end
end
