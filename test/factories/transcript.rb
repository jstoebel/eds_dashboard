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
#  gpa_credits       :float(24)
#  reg_status        :string(45)
#  Inst_bnum         :string(45)
#

include Faker
FactoryGirl.define do
  factory :transcript do

    student
    crn {"#{Number.number 4}"}
    course_code {"EDS#{Number.between 100, 499}"}
    course_name {Book.title}

    #must provide a term
    
    grade_pt {[4.0, 3.7, 3.3, 3.0, 2.7, 2.3, 2.0, 1.7, 1.3, 1.0, 0.7, 0.0, nil].sample}

  end
end
