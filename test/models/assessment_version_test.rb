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
  
  test "Not valid object, needs assessment_id" do
    ver = AssessmentVersion.new
    assert_not ver.valid?
    assert_equal [:assessment_id], ver.errors.keys
    assert_equal [:assessment_id].map{|i| [i, ["Assessment must be selected."]]}.to_h, 
      ver.errors.messages
  end
  
  test "sorted scope" do
    ver = FactoryGirl.create_list(:assessment_version, 3)
    ordered_vers = ver.order
    assert_equal ver.sorted, ordered_vers
  end
  
  test "has_scores" do
    
  end
  
  test "version_num" do 
    
  end
end
