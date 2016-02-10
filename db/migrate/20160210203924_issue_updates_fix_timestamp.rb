class IssueUpdatesFixTimestamp < ActiveRecord::Migration
  def up
    execute %q(ALTER TABLE `issue_updates` 
    CHANGE COLUMN `CreateDate` `CreateDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ;)
  end

  def down
    execute %q(ALTER TABLE `issue_updates` 
    CHANGE COLUMN `CreateDate` `CreateDate` DATETIME NOT NULL ;)
  end

end
