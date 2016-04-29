# == Schema Information
#
# Table name: employment
#
#  student_id  :integer          not null
#  EmpID       :integer          not null, primary key
#  EmpDate     :date             not null
#  EmpCategory :string(45)
#  Employer    :string(45)
#

class Employment < ActiveRecord::Base
  self.table_name = 'employment'
end
