class StatusToIssueUpdate < ActiveRecord::Migration
  def up
    remove_column :issues, :Open
    add_column :issue_updates, :status, :string
  end

  def down
    remove_column :issue_updates, :status
    add_column :issues, :Open, :boolean

  end
end
