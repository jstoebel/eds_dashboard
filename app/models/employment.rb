# == Schema Information
#
# Table name: employment
#
#  id         :integer          not null, primary key
#  student_id :integer
#  category   :integer
#  employer   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Employment < ActiveRecord::Base
  self.table_name = 'employment'
end
