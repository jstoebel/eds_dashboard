class IssueUpdate < ActiveRecord::Base
	belongs_to :issue, foreign_key: 'Issues_IssueID'

	scope :sorted, lambda {order(:CreateDate => :asc)}

	validate do |iu|
		iu.errors.add(:base, "Issue update must have a name.") if iu.UpdateName.blank?
		iu.errors.add(:base, "Issue update may not be more than 100 characters.") if iu.UpdateName.size > 100		
	end
	validates :Description, presence: true

	scope :sorted, lambda {order(:CreateDate => :desc)}

end
