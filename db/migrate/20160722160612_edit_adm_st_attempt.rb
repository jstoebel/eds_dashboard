class EditAdmStAttempt < ActiveRecord::Migration
  def up
    change_column :adm_st, :Attempt, :integer, :null => true
  end

  def down
    change_column :adm_st, :Attempt, :integer, :null => false
  end
end
