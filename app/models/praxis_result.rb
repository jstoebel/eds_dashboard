class PraxisResult < ActiveRecord::Base

	belongs_to :student
	hsa_many :praxis_subtest_result
end
