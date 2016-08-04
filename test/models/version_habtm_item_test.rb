# == Schema Information
#
# Table name: version_habtm_items
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

require 'test_helper'

class VersionHabtmItemTest < ActiveSupport::TestCase

  test "Object not valid, validations fail" do
    ver_item=VersionHabtmItem.new
    assert_not ver_item.valid?
    assert_equal [:assessment_version_id, 
      :assessment_item_id] ,
      ver_item.errors.keys
    assert_equal [:assessment_version_id, :assessment_item_id].map{|i| [i, ["can't be blank"]]}.to_h, 
      ver_item.errors.messages
  end
  
  test "has_version_id? return true" do
    ver_item = FactoryGirl.create :version_habtm_item
    assert_equal ver_item.has_version_id?, ver_item.assessment_version_id.present?
  end
  
  test "has_version_id? return false" do
    ver_item = VersionHabtmItem.new
    assert_equal ver_item.has_version_id?, ver_item.assessment_version_id.present?
  end
  
  test "ver_locked return true" do
    # would occur if version has no scores and can be validated
    ver_item = FactoryGirl.create :version_habtm_item    #no scores
    ver = AssessmentVersion.find_by(id: ver_item.assessment_version_id)
    assert_equal ver_item.ver_locked, ver.has_scores == false
  end
  
  test "ver_locked return false" do
    # would occur if version has scores and cannot be validated
    ver = FactoryGirl.create :version_with_items    #has scores
    ver_item = VersionHabtmItem.find_by(assessment_version_id: ver.id)
    #false, and false because ver.has_scores == true
    assert_equal ver_item.ver_locked, ver.has_scores == false
  end
end