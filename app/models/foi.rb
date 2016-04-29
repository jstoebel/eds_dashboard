# == Schema Information
#
# Table name: forms_of_intention
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  date_completing :datetime
#  new_form        :boolean
#  major_id        :integer
#  seek_cert       :boolean
#  eds_only        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  forms_of_intention_major_id_fk    (major_id)
#  forms_of_intention_student_id_fk  (student_id)
#

class Foi < ActiveRecord::Base
  self.table_name = 'forms_of_intention'
  belongs_to :student
  belongs_to :major

end
