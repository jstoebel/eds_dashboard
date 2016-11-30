# == Schema Information
#
# Table name: clinical_teachers
#
#  id                  :integer          not null, primary key
#  Bnum                :string(45)
#  FirstName           :string(45)       not null
#  LastName            :string(45)       not null
#  Email               :string(45)
#  Subject             :string(45)
#  clinical_site_id    :integer          not null
#  Rank                :integer
#  YearsExp            :integer
#  begin_service       :datetime
#  epsb_training       :datetime
#  ct_record           :datetime
#  co_teacher_training :datetime
#

module ClinicalTeachersHelper
end
