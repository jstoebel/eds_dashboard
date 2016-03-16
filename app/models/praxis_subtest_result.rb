class PraxisSubtestResult < ActiveRecord::Base
	belongs_to :praxis_result, {:foreign_key => [:praxis_results_Student_Bnum, :praxis_results_TestCode, :praxis_results_TestDate]}
end
