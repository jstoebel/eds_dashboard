# == Schema Information
#
# Table name: assessment_item_versions
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  item_code             :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#
# Indexes
#
#  assessment_item_versions_assessment_item_id_fk     (assessment_item_id)
#  assessment_item_versions_assessment_version_id_fk  (assessment_version_id)
#

require 'test_helper'

class AssessmentItemVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
