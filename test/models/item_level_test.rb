# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
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
    lev = FactoryGirl.create(:item_level, {:descriptor => nil, :level => nil})
    assert_not lev.valid?    #not a valid object
    #error due to all required attributes?
    assert_equal [:descriptor, :level, :assessment_item_id], lev.errors.keys
    assert_equal [:descriptor, :level, :assessment_item_id].map{|i| [i, ["can't be blank"]]}.to_h, 
      lev.errors.messages
  end
  
  test "Sorted scope" do
    num_lvl = 3
    levels = FactoryGirl.create_list(:item_level, num_lvl)
    ordered_lvls = levels.sort_by{ |l| l.ord}
    assert_equal ordered_lvls, ItemLevel.sorted
  end
  
  test "validation of descriptor" do
    level = ItemLevel.new
    
  end
  
end
