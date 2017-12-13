# == Schema Information
#
# Table name: employment
#
#  EmpID       :integer          not null, primary key
#  student_id  :integer          not null
#  EmpDate     :date             not null
#  EmpCategory :string(45)
#  Employer    :string(45)
#

class Employment < ApplicationRecord
  self.table_name = 'employment'
end
