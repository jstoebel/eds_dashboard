# == Schema Information
#
# Table name: assessment_items
#
#  id            :integer          not null, primary key
#  assessment_id :integer
#  name          :string(255)
#  slug          :string(255)
#  start_term    :integer
#  end_term      :integer
#  description   :text(65535)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class AssessmentItemTest < ActiveSupport::TestCase

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

  describe "unique within assessment" do

    [:name, :description].each do |attr|
      test attr do

        first_item = FactoryGirl.create :assessment_item
        second_item = FactoryGirl.build :assessment_item, first_item.attributes

        assert_not second_item.valid?
        assert_equal ["An item with that #{attr} already exists for this assessment"],
          second_item.errors[attr]

      end
    end

  end

  test "Sorted scope" do
    num_item = 3
    items = FactoryGirl.create_list(:assessment_item, num_item)
    ordered_items = items.sort_by{ |i| i.name }
    assert_equal ordered_items, AssessmentItem.sorted
  end

  test "repr" do
    ai = FactoryGirl.create :assessment_item
    assert_equal ai.slug, ai.repr
  end

end
