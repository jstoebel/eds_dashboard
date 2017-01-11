# == Schema Information
#
# Table name: transcript
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  crn               :string(45)       not null
#  course_code       :string(45)       not null
#  course_section    :string(255)
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

require 'test_helper'
require 'factory_girl'
class TranscriptTest < ActiveSupport::TestCase

    let(:four_point_oh) {Transcript.l_to_g "A"}
    let(:a_grade) {Transcript.g_to_l 4.0}

    test "student in course in term is unique" do
        attrs = {
            :student => (FactoryGirl.create :student),
            :crn => "1001",
            :banner_term => (FactoryGirl.create :banner_term)
        }

        t1 = FactoryGirl.create :transcript, attrs
        t2 = FactoryGirl.build :transcript, attrs

        assert_not t2.valid?
        assert_equal ["Crn student may not have duplicates of the same course in the same term."], t2.errors.full_messages
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

    describe "validates reuqired columns" do

        required_attrs = [:student_id, :crn, :course_code, :term_taken]

        required_attrs.each do |a|
            it "validates #{a}" do
                t = FactoryGirl.build :transcript, {a => nil}
                assert_not t.valid?
                assert_equal ["#{a.to_s.humanize} can't be blank"], t.errors.full_messages

            end
        end
    end

    it "returns inst_bnums" do
      course = FactoryGirl.create :transcript
      expected_bnums = course.instructors.split(";").map{|r| r.match(/\{(.+)\}/)[1]}
      assert_equal expected_bnums, course.inst_bnums

    end

    it "returns inst_bnums - no instructors" do
      course = FactoryGirl.create :transcript, {:instructors => nil}
      assert_equal [], course.inst_bnums

    end


end
