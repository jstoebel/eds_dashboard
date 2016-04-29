# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  ProgStatus       :string(45)       default("Prospective")
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  CurrentMajor2    :string(45)
#  TermMajor        :integer
#  PraxisICohort    :string(45)
#  PraxisIICohort   :string(45)
#  CellPhone        :string(45)
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#
# Indexes
#
#  Bnum_UNIQUE  (Bnum) UNIQUE
#

FactoryGirl.define do
  factory :student do
    sequence(:Bnum) { |b| "B#{b.to_s.rjust(6, '0')}" }
    FirstName "Ima"
    LastName "Student"
    sequence(:AltID) { |i| "#{i}" }

    factory :prospective do
        ProgStatus "Prospetive"
        EnrollmentStatus "Active Student"
    end

    factory :candidate do
        ProgStatus "Candidate"
        EnrollmentStatus "Active Student"
    end

    factory :graduate_candidate do
        ProgStatus "Candidate"
        EnrollmentStatus "Graduation"
    end

    factory :graduate_completer do
        ProgStatus "Completer"
        EnrollmentStatus "Graduation"
    end
  end
end
