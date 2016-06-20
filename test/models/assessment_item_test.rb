# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class AssessmentItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "not valid object, validations fail" do
    assess_items = AssessmentItem.new
    assert_not assess_items.valid?
    assert_equal [:slug, :name], assess_items.errors.keys
  end
end
