class EditAdmTep < ActiveRecord::Migration
  def up
    change_column :adm_tep, :Attempt, :integer, :null => true
  end

  def down
    change_column :adm_tep, :Attempt, :integer, :null => false
  end
end
