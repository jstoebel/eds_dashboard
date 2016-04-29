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
# Indexes
#
#  praxis_subtest_results_praxis_result_id_fk  (praxis_result_id)
#

class PraxisSubtestResult < ActiveRecord::Base
	belongs_to :praxis_result
end
