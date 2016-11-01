require 'csv'
namespace :temp do
  task :fix_issues => :environment do |task|

    data_loc = Rails.root.join("lib", "tasks", "temp", "fixed_issues.csv")
    puts "WARNING! You are about to erase all issues and issue_updates and recreate from the csv located at #{data_loc}. Are you sure? [Y/n]"
    confirm = STDIN.gets.chomp
    fail("task canceled by user") if confirm != "Y"

    # remove all issue_updates and issues
    Issue.transaction do
      IssueUpdate.delete_all
      Issue.delete_all

      CSV.foreach(data_loc, headers: true) do |row|
        # create issue from csv.

        issue_attr = row.to_hash
        puts issue_attr
        issue = Issue.create! issue_attr

        # create update with status derived from positive
        IssueUpdate.create!({
            :UpdateName => "Issue opened",
            :Description => "Issue opened",
            :Issues_IssueID => issue.id,
            :tep_advisors_AdvisorBnum => issue.tep_advisors_AdvisorBnum,
            :created_at => issue.created_at,
            :updated_at => issue.updated_at,
            :addressed => false,
            :status => issue.positive ? "resolved" : "concern"
          })
        end # csv

    end # transaction

    puts "records replaced!"
  end # task
end # scope
