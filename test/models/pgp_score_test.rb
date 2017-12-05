# == Schema Information
#
# Table name: pgp_scores
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PgpScoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
