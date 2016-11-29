# == Schema Information
#
# Table name: adm_st
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  BannerTerm_BannerTerm :integer
#  Attempt               :integer
#  OverallGPA            :float(24)
#  CoreGPA               :float(24)
#  STAdmitted            :boolean
#  STAdmitDate           :datetime
#  STTerm                :integer
#  Notes                 :text(65535)
#  background_check      :boolean
#  beh_train             :boolean
#  conf_train            :boolean
#  kfets_in              :boolean
#  created_at            :datetime
#  updated_at            :datetime
#  student_file_id       :integer
#

FactoryGirl.define do
  # TODO: a pending app and a processed app

  factory :pending_adm_st, class: AdmSt do
    student
    banner_term
    Attempt 1
    OverallGPA 2.75
    CoreGPA 3.0
  end # factory

  factory :accepted_adm_st, class: AdmSt do
    student
    banner_term
    Attempt 1
    STAdmitted true
    OverallGPA 2.75
    CoreGPA 3.0
    student_file

    after(:build) do |app|
      app.STAdmitDate = app.banner_term.StartDate
    end # build
  end # factory

  factory :denied_adm_st, class: AdmSt do
    student
    banner_term
    Attempt 1
    STAdmitted false
    OverallGPA 2.75
    CoreGPA 3.0
    student_file

  end # factory

end
