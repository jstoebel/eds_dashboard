# == Schema Information
#
# Table name: transcript
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  crn               :string(45)       not null
#  course_code       :string(45)       not null
#  course_name       :string(100)
#  term_taken        :integer          not null
#  grade_pt          :float(24)
#  grade_ltr         :string(2)
#  quality_points    :float(24)
#  credits_attempted :float(24)
#  credits_earned    :float(24)
#  reg_status        :string(45)
#  instructors       :text(65535)
#  gpa_include       :boolean          not null
#

include Faker
FactoryGirl.define do
  factory :transcript do

    association :student
    sequence(:crn) { |n| (1000 + n.to_i).to_s}
    course_code {"EDS#{Number.between 100, 499}"}
    course_name {Book.title}

    #must provide a term
    term_taken {BannerTerm.first.andand.id}

    grade_pt {[4.0, 3.7, 3.3, 3.0, 2.7, 2.3, 2.0, 1.7, 1.3, 1.0, 0.7, 0.0, nil].sample}
    credits_earned 1.0
    credits_attempted 1.0
    gpa_include true
    instructors { 2.times.map{"#{Name.first_name} #{Name.last_name} {#{"B00"+Number.between(0, 10**6).to_s.rjust(6, '0')}}"}.join("; ") } #format FirstName LastName {B00123456}; FirstName LastName {B00687001}
  end
end
