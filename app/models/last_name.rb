# == Schema Information
#
# Table name: last_names
#
#  id         :integer          not null, primary key
#  student_id :integer
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LastName < ApplicationRecord
	belongs_to :student
	validates_presence_of :student_id
end
