class UpdateResolved < ActiveRecord::Migration
  def up
    add_column :issue_updates, :addressed, :bool
  end

  def down
      remove_column :issue_updates, :addressed
  end
end
