# == Schema Information
#
# Table name: adm_tep
#
#  student_id            :integer          not null
#  id                    :integer          not null, primary key
#  Program_ProgCode      :integer          not null
#  BannerTerm_BannerTerm :integer          not null
#  Attempt               :integer          not null
#  GPA                   :float(24)
#  GPA_last30            :float(24)
#  EarnedCredits         :integer
#  PortfolioPass         :boolean
#  TEPAdmit              :boolean
#  TEPAdmitDate          :datetime
#  Notes                 :text
#  student_file_id       :integer
#
# Indexes
#
#  adm_tep_student_file_id_fk  (student_file_id)
#  adm_tep_student_id_fk       (student_id)
#  fk_AdmTEP_BannerTerm1_idx   (BannerTerm_BannerTerm)
#  fk_AdmTEP_Program1_idx      (Program_ProgCode)
#

FactoryGirl.define do
  factory :adm_tep do
    sequence(:id) { |i| i }
    association :student, factory: :prospective
    # need to provide Program_ProgCode
    # need to provide BannerTerm_BannerTerm
    Attempt 1
    TEPAdmit true
    TEPAdmitDate Date.today
    GPA 2.75
    GPA_last30 3.0 
    EarnedCredits 30
    association :student_file, factory: :student_file
  end
end
