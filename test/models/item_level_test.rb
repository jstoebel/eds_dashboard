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
end
