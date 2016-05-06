class IssueIssueupdateFk < ActiveRecord::Migration
  def up
    remove_foreign_key :issues, :name => "fk_Issues_tep_advisors"

    change_table :issues do |t|
      t.change :tep_advisors_AdvisorBnum, :integer, :null => false
      t.change :Name, :text
    end
    add_foreign_key :issues, :tep_advisors, :column => "tep_advisors_AdvisorBnum"

    remove_foreign_key :issue_updates, :name => "fk_IssueUpdates_tep_advisors"

    change_table :issue_updates do |t|
      t.change :tep_advisors_AdvisorBnum, :integer, :null => false
      t.change :UpdateName, :text
    end
    change_column :issue_updates, :tep_advisors_AdvisorBnum, :integer, :null => false
    add_foreign_key :issue_updates, :tep_advisors, :column => "tep_advisors_AdvisorBnum"

  end

  def down
    remove_foreign_key :issues, :name => "issues_tep_advisors_AdvisorBnum_fk"

    change_table :issues do |t|
      t.change :tep_advisors_AdvisorBnum, :string, :null => true
      t.change :Name, :string, :length => 100
    end
    add_foreign_key "issues", "tep_advisors", name: "fk_Issues_tep_advisors", column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"

    remove_foreign_key :issue_updates, :name => "issue_updates_tep_advisors_AdvisorBnum_fk"
    
    change_table :issue_updates do |t|
      t.change :tep_advisors_AdvisorBnum, :string, :null => true
      t.change :UpdateName, :string
    end

    add_foreign_key "issue_updates", "tep_advisors", name: "fk_IssueUpdates_tep_advisors", column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"

  end
end
