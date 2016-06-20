# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  version_num   :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class AssessmentVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Not valid object, validations fail" do
    assess_ver = AssessmentVersion.new
    assert_not assess_ver.valid?
    assert_equal [:assessment_id], assess_ver.errors.keys
  end
end
