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

require 'test_helper'

class TranscriptTest < ActiveSupport::TestCase

    test "student in course in term is unique" do
        t1 = Transcript.create({:student_id => Student.first.id,
            :crn => "1001",
            :course_code => "EDS150",
            :course_name => "Intro Class",
            :term_taken => BannerTerm.first.id,
            :gpa_include => true})

        assert_raises ActiveRecord::RecordNotUnique do
            Transcript.create t1.attributes #try to make the same record
        end
    end

end
