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
  # test "the truth" do
  #   assert true
  # end
end
