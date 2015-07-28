class Issue < ActiveRecord::Base

	belongs_to :student
	has_many :issue_updates, {:foreign_key => 'Issues_IssueID'}

	validates :Name, :length => { maximum: 100}
	validates :Name, :Description, presence: true


	scope :sorted, lambda {order(:Open => :desc, :CreateDate => :desc)}
end
