class IssueUpdatesTimestamps < ActiveRecord::Migration
  def up
    change_table :issue_updates do |t|
        t.remove :CreateDate
        t.timestamps
    end

  end

  def down
    change_table :issue_updates do |t|
        t.remove :created_at
        t.remove :updated_at
        t.datetime :CreateDate
    end
  end
end
