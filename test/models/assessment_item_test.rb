# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  description :text
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
  
  test "has_scores? is true" do
    ver = FactoryGirl.create :version_with_items
    item = ver.student_scores.first.assessment_item
    item.assessment_versions.each do |v|
      if v.has_scores == true
        outcome = v.has_scores
        break
      end
    end
    puts outcome
    assert_equal item.has_scores?, outcome
  end
  
  test "has_scores? is false" do 
  end
  
  test "check_scores" do
    
  end
end
