class AddPresumedStatus < ActiveRecord::Migration
  def up
    add_column :students, :presumed_status, :string
  end

  def down
    remove_column :students, :presumed_status
  end
end
