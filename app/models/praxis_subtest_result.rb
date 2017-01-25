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

class PraxisSubtestResult < ActiveRecord::Base
	belongs_to :praxis_result

	validates_presence_of :praxis_result_id

	def student
		return self.praxis_result.student
	end

end
