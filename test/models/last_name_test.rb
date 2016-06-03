# == Schema Information
#
# Table name: last_names
#
#  id         :integer          not null, primary key
#  student_id :integer
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class LastNameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
