# == Schema Information
#
# Table name: tep_advisors
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  AdvisorBnum :string(9)        not null
#  Salutation  :string(255)
#  user_id     :integer
#

class TepAdvisor < ActiveRecord::Base
	self.table_name = "tep_advisors"

    #ASSOCIATIONS
	has_many :advisor_assignments
	has_many :students
	belongs_to :user

    #VALIDATIONS

    validates_presence_of :name, :AdvisorBnum

end
