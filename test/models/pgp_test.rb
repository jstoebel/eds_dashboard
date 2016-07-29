# == Schema Information
#
# Table name: pgps
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  goal_name   :string(255)
#  description :text(65535)
#  plan        :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class PgpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
