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
# Indexes
#
#  assessment_versions_assessment_id_fk  (assessment_id)
#

require 'test_helper'

class AssessmentVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
