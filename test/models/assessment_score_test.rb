# == Schema Information
#
# Table name: assessment_scores
#
#  id                         :integer          not null, primary key
#  student_assessment_id      :integer          not null
#  assessment_item_version_id :integer          not null
#  score                      :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

require 'test_helper'

class AssessmentScoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
