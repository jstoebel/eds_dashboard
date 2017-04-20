# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(45)       not null
#  user_id     :integer
#  first_name  :string(255)      not null
#  last_name   :string(255)      not null
#  email       :string(255)
#

class TepAdvisor < ApplicationRecord
	self.table_name = "tep_advisors"

	has_many :advisor_assignments
	has_many :students

	belongs_to :user

	def get_email
		# gets the advisor's email, if it doesn't exists looks in user
		return self.email if self.email.present?
		return self.user.andand.Email
	end
end
