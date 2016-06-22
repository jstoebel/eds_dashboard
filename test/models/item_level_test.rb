# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class ItemLevelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Object not valid, validations failed" do
    lev = ItemLevel.new
    assert_not lev.valid?    #not a valid object
    #error due to all required attributes?
    assert_equal [:descriptor, :level, :assessment_item_id], lev.errors.keys
    assert_equal [:descriptor, :level, :assessment_item_id].map{|i| [i, ["can't be blank"]]}.to_h, 
      lev.errors.messages
  end
end