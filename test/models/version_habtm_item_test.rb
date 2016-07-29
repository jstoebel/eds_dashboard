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
  # test "the truth" do
  #   assert true
  # end
  test "Object not valid, validations fail" do
    ver_item=VersionHabtmItem.new
    assert_not ver_item.valid?
    assert_equal [:assessment_version_id, 
      :assessment_item_id] ,
      ver_item.errors.keys
    assert_equal [:assessment_version_id, :assessment_item_id].map{|i| [i, ["can't be blank"]]}.to_h, 
      ver_item.errors.messages
  end
end
