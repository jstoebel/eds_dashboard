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
#  Inst_bnum         :string(45)
#  gpa_include       :boolean          not null
#

require 'test_helper'
require 'factory_girl'
class TranscriptTest < ActiveSupport::TestCase

    let(:four_point_oh) {Transcript.l_to_g "A"}
    let(:a_grade) {Transcript.g_to_l 4.0}

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

    test "sets quality points" do
        t = FactoryGirl.create :transcript, {
            term_taken: BannerTerm.first.id,
            grade_pt: 4.0
        }
        assert t.quality_points.present?
    end

    test "does not set quality points, nil grade" do
        t = FactoryGirl.create :transcript, {
            term_taken: BannerTerm.first.id,
            grade_pt: nil
        }
        assert t.quality_points.blank?
    end

    it "converts letter to grade" do
       expect four_point_oh.must_equal 4.0 
    end

    it "converts grade to letter" do
        expect a_grade.must_equal "A"
    end

end
