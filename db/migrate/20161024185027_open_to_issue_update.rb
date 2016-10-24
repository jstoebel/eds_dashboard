class OpenToIssueUpdate < ActiveRecord::Migration
  def up
    remove_column :issues, :Open
    add_column :issue_updates, :open, :boolean
  end

  def down
    remove_column :issue_updates, :open
    add_column :issues, :Open, :boolean

  end
end
