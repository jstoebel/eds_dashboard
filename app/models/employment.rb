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
# Indexes
#
#  employment_student_id_fk  (student_id)
#

class Employment < ActiveRecord::Base
  self.table_name = 'employment'
end
