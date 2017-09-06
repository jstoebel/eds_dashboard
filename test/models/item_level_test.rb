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
#  passing            :boolean
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
     first_level = FactoryGirl.create :item_level
     second_level = FactoryGirl.build :item_level, :ord => first_level.ord
     assert second_level.valid?
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

  describe "unique within assessment_item" do

    before do
      first_item = FactoryGirl.create :item_level
      @second_item = FactoryGirl.build :item_level, first_item.attributes
    end

    [:descriptor, :ord].each do |attr|
      test attr do
        assert_not @second_item.valid?
        assert_equal ["A level with that #{attr} already exists for this assessment_item"],
          @second_item.errors[attr]
      end
    end

    test "for level" do
      assert_not @second_item.valid?
      assert_equal ["A level with that level number already exists for this assessment_item"],
        @second_item.errors[:level]
    end

  end
end
