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
    ver.push(FactoryGirl.create(:assessment_version, :assessment_id => ver[1].assessment_id))
    ordered_vers = ver.sort_by { |a| [a.assessment_id, a.created_at]}
    puts ordered_vers.inspect
    assert (0..2).each do |i|
      ordered_vers[i].assessment_id < ordered_vers[i+1].assessment_id
    end
=begin    assert (0..2).each do |i|
      ordered_vers[i].assessment_id < ordered_vers[i+1].assessment_id
=end
    assert_equal ver.sorted, ordered_vers  ##Ask Jacob how to test scopes
  end
  
  test "has_scores" do
    ver = FactoryGirl.create :version_with_items
    score = ver.student_scores.present?.size < 0
    assert_equal ver.has_scores, score
  end
  
  test "version_num" do 
    
  end
end
