# == Schema Information
#
# Table name: adm_tep
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  Program_ProgCode      :integer          not null
#  BannerTerm_BannerTerm :integer          not null
#  Attempt               :integer
#  GPA                   :float(24)
#  GPA_last30            :float(24)
#  EarnedCredits         :integer
#  PortfolioPass         :boolean
#  TEPAdmit              :boolean
#  TEPAdmitDate          :datetime
#  Notes                 :text(65535)
#  student_file_id       :integer
#

FactoryGirl.define do
  factory :adm_tep do
    association :student    #links to student object factory
    # association :program
    # association :banner_term
    # need to provide Program_ProgCode
    # need to provide BannerTerm_BannerTerm
    program
    Attempt 1
    TEPAdmit true
    TEPAdmitDate Date.today
    GPA 2.75
    GPA_last30 3.0
    EarnedCredits 30
    association :student_file, factory: :student_file
  end
end
