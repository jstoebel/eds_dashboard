# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer
#  descriptor         :text(65535)
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#  cut_score          :boolean
#

require 'test_helper'

class ItemLevelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Parameters not valid, validations failed" do
    lev = ItemLevel.new
    assert_not lev.valid?    #not a valid object
    #error due to all required attributes?
    assert_equal [:descriptor, :level, :assessment_item_id], lev.errors.keys
    assert_equal [:descriptor, :level, :assessment_item_id].map{|i| [i, ["can't be blank"]]}.to_h,
      lev.errors.messages
  end

   test "ord is unique" do
     #test that the :ord attribute of levels of an item are unique
     item = FactoryGirl.create :assessment_item
     levels = FactoryGirl.create_list(:item_level, 4, :assessment_item_id => item.id)
     orders = []
     levels.each{|l| orders.push(l.ord)}
     #asserts unique values in array are equal to the original array
     assert_equal orders.uniq, orders
   end

  test "ord is not unique, error" do
    #test that error occurs due to duplicate :ord attributes
    item = FactoryGirl.create :assessment_item
    levels = FactoryGirl.create_list(:item_level, 4, :assessment_item_id => item.id)
    lvl = FactoryGirl.build :item_level, {:assessment_item_id => item.id, :ord => levels.first.ord}
    assert_not lvl.valid?
    assert_equal [:ord].map{|i| [i, ["has already been taken"]]}.to_h,
      lvl.errors.messages
   end

  test "Sorted scope" do
    num_lvl = 3
    levels = FactoryGirl.create_list(:item_level, num_lvl)
    ordered_lvls = levels.sort_by{ |l| l.ord}
    assert_equal ordered_lvls, ItemLevel.sorted
  end

  test "has_item_id? return false" do
    level = ItemLevel.new
    assert_equal level.has_item_id?, level.assessment_item_id.present?
  end

  test "has_item_id? return true" do
    level = FactoryGirl.create :item_level
    assert_equal level.has_item_id?, level.assessment_item_id.present?
  end

  test "repr" do
    il = FactoryGirl.create :item_level
    assert_equal il.descriptor, il.repr
  end
end
