# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(45)       not null
#  user_id     :integer          not null
#

class TepAdvisor < ActiveRecord::Base
	self.table_name = "tep_advisors"

	has_many :advisor_assignments
	has_many :students

	belongs_to :user
end
