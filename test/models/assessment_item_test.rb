# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

require 'test_helper'

class AssessmentItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "Should destroy dependent levels" do
    lvl = FactoryGirl.create :item_level
    item = lvl.assessment_item
    item.destroy!
    assert item.destroyed?
    assert_not ItemLevel.exists?(lvl.id)
  end

  test "not valid object, validations fail" do
    assess_item = AssessmentItem.new
    assert_not assess_item.valid?
    assert_equal [:name, :slug], assess_item.errors.keys
    assert_equal [:name, :slug].map{|i| [i, ["can't be blank"]]}.to_h,
      assess_item.errors.messages
  end
  
  test "Sorted scope" do
    num_item = 3
    items = FactoryGirl.create_list(:assessment_item, num_item)
    ordered_items = items.sort_by{ |i| i.name }
    assert_equal ordered_items, AssessmentItem.sorted
  end
  
  test "has_scores? is true" do
    ver = FactoryGirl.create :version_with_items
    item = ver.student_scores.first.assessment_item
    scores = item.assessment_versions.select {|v| v.student_scores.present?}.size > 0 #are there are any scores attached to any versions?
    assert_equal item.has_scores?, scores
  end
  
  test "has_scores? is false" do
    item = FactoryGirl.create :assessment_item
    #are there are any scores attached to any versions?
    scores = item.assessment_versions.select {|v| v.student_scores.present?}.size > 0
    assert_equal item.has_scores?, scores
  end
  
   test "check_scores returns true" do
     #check_scores returns true if no scores and false if has scores
     no_score = FactoryGirl.create :assessment_item
     assert no_score.check_scores
   end
  
  test "check_scores returns false" do
    ver = FactoryGirl.create :version_with_items
    with_score = ver.student_scores.first.assessment_item
    assert_not with_score.check_scores
  end
end
