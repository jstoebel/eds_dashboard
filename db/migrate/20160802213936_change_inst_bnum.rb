class ChangeInstBnum < ActiveRecord::Migration
  def up
    rename_column :transcript, :Inst_bnum, :instructors
  end

  def down
    rename_column :transcript, :instructors, :Inst_bnum
  end
end
