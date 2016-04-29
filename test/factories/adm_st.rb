# == Schema Information
#
# Table name: adm_st
#
#  student_id            :integer          not null
#  id                    :integer          not null, primary key
#  BannerTerm_BannerTerm :integer
#  Attempt               :integer          not null
#  OverallGPA            :float(24)
#  CoreGPA               :float(24)
#  STAdmitted            :boolean
#  STAdmitDate           :datetime
#  STTerm                :integer
#  Notes                 :text
#  background_check      :boolean
#  beh_train             :boolean
#  conf_train            :boolean
#  kfets_in              :boolean
#  created_at            :datetime
#  updated_at            :datetime
#  student_file_id       :integer
#
# Indexes
#
#  adm_st_student_file_id_fk  (student_file_id)
#  adm_st_student_id_fk       (student_id)
#  fk_AdmST_BannerTerm1_idx   (BannerTerm_BannerTerm)
#

FactoryGirl.define do
  factory :adm_st do

    #make the adm_st for the same student who has this adm_tep!
    # need to provide Bnum
    #need to provide the BannerTerm_BannerTerm
    Attempt 1
    STAdmitted true
    STAdmitDate Date.today
    OverallGPA 2.75
    CoreGPA 3.0
    association :student_file, factory: :student_file
  end
end
