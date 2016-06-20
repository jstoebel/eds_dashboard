class EditIssueUpdate < ActiveRecord::Migration

  def up
    change_table :issue_updates do |t|
        t.boolean :visible, :null => false, default: true
    end
  end
  
  def down
    change_table :issue_updates do |t|
        t.remove :visible
    end
  end
  
end
