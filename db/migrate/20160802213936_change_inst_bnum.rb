class ChangeInstBnum < ActiveRecord::Migration
  def up
    rename_column :transcript, :Inst_bnum, :instructors
    change_column :transcript, :instructors, :text
  end

  def down
    change_column :transcript, :instructors, :string
    rename_column :transcript, :instructors, :Inst_bnum
  end
end
