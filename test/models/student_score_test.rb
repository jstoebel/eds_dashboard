# == Schema Information
#
# Table name: student_scores
#
#  id                    :integer          not null, primary key
#  student_id            :integer
#  assessment_version_id :integer
#  item_level_id         :integer
#  assessment_item_id    :integer
#

require 'test_helper'

class StudentScoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
