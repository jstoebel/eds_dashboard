# == Schema Information
#
# Table name: clinical_assignments
#
#  id                  :integer          not null, primary key
#  student_id          :integer          not null
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#  transcript_id       :integer
#

include Faker
FactoryGirl.define do
  factory :clinical_assignment do
    association :student
    association :clinical_teacher
    banner_term
    CourseID {Lorem.characters 6}
    Level {Faker::Number.between(1,3)}

    after(:build) do |assignment|
      [:StartDate, :EndDate].each do |attr|
        assignment[attr] = assignment.banner_term.send(attr)
      end
    end

  end
end
