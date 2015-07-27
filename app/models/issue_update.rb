class IssueUpdate < ActiveRecord::Base
	belongs_to :issue

	scope :sorted, lambda {order(:CreateDate => :asc)}

end
