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
  
  test "not valid object, validations fail" do
    assess_item = AssessmentItem.new
    assert_not assess_item.valid?
    assert_equal [:name, :slug], assess_item.errors.keys
    assert_equal [:name, :slug].map{|i| [i, ["can't be blank"]]}.to_h,
      assess_item.errors.messages
  end
end
