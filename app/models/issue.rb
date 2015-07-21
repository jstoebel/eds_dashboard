class Issue < ActiveRecord::Base

	belongs_to :student
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}
end
