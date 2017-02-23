# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class AssessmentVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Should destroy dependent version_habtm_items" do
    item_ver = FactoryGirl.create :version_habtm_item
    ver = AssessmentVersion.find_by(:id => item_ver.assessment_version_id)
    ver.destroy!
    assert ver.destroyed?
    assert_not VersionHabtmItem.exists?(item_ver.id)
  end

  test "Not valid object, needs assessment_id" do
    ver = AssessmentVersion.new
    assert_not ver.valid?
    assert_equal [:assessment_id], ver.errors.keys
    assert_equal [:assessment_id].map{|i| [i, ["Assessment must be selected."]]}.to_h,
      ver.errors.messages
  end

  test "sorted scope" do
    num_ver = 3
    ver = FactoryGirl.create_list(:assessment_version, num_ver)
    sleep(2)    #so created_at will be different to check ordering
    #add sibling of element in index 1 to front of array
    ver.unshift(FactoryGirl.create(:assessment_version, :assessment_id => ver[1].assessment_id))
    ordered_vers = ver.sort_by{ |a| [a.assessment_id, a.created_at]}    #first by assessment_id, then by created_at
    sort_ver = AssessmentVersion.sorted
    assert_equal ordered_vers, sort_ver
  end

  test "has_scores returns true" do
    ver = FactoryGirl.create :version_with_items
    assert ver.has_scores
  end

  test "has_scores returns false" do
    ver = FactoryGirl.create :assessment_version
    assert_not ver.has_scores
  end

  test "version_num" do
    ver = FactoryGirl.create :assessment_version
    assess = ver.assessment
    sleep(2)
    sib_ver = FactoryGirl.create :assessment_version, :assessment_id => assess.id
    vers = assess.assessment_versions
    vers.sort_by{|v| v.created_at}
    expected = vers.find_index(sib_ver) + 1
    actual = sib_ver.version_num
    assert_equal expected, actual
  end

  test "repr" do
    ver = FactoryGirl.create :assessment_version
    assert_equal "#{ver.assessment.name}-#{ver.version_num}", ver.repr
  end

  test "repr-new record" do
    ver = AssessmentVersion.new
    assert_equal "new version", ver.repr
  end

end
