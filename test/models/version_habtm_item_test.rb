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
