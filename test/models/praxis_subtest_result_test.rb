# == Schema Information
#
# Table name: praxis_subtest_results
#
#  id               :integer          not null, primary key
#  praxis_result_id :integer          not null
#  sub_number       :integer
#  name             :string(255)
#  pts_earned       :integer
#  pts_aval         :integer
#  avg_high         :integer
#  avg_low          :integer
#

require 'test_helper'

class PraxisSubtestResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
