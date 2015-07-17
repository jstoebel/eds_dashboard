class PraxisResult < ActiveRecord::Base

	belongs_to :student
	has_many :praxis_subtest_results, {:foreign_key => 'praxis_results_TestID'}
end
