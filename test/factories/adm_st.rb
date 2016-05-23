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

FactoryGirl.define do
  factory :adm_st do

    #make the adm_st for the same student who has this adm_tep!
    # need to provide Bnum
    #need to provide the BannerTerm_BannerTerm
    association :student
    Attempt 1
    STAdmitted true
    STAdmitDate Date.today
    OverallGPA 2.75
    CoreGPA 3.0
    association :student_file, strategy: :build
  end
end
