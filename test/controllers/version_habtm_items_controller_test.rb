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

class VersionHabtmItemsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end
