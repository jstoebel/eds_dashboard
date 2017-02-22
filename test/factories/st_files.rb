# == Schema Information
#
# Table name: st_files
#
#  id              :integer          not null, primary key
#  adm_st_id       :integer
#  student_file_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :st_file do
    student_file
    accepted_adm_st
  end
end
