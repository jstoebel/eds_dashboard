# == Schema Information
#
# Table name: alumni_info
#
#  AlumniID     :integer          not null, primary key
#  Student_Bnum :string(9)        not null
#  Date         :datetime
#  FirstName    :string(45)
#  LastName     :string(45)
#  Email        :string(45)
#  Phone        :string(45)
#  Address1     :string(45)
#  Address2     :string(45)
#  City         :string(45)
#  State        :string(45)
#  ZIP          :string(45)
#
# Indexes
#
#  fk_AlumniInfo_Student1_idx  (Student_Bnum)
#

class AlumniInfo < ActiveRecord::Base
  self.table_name = 'alumni_info'
end
