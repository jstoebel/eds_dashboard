class PraxisTest < ActiveRecord::Base

	has_many :praxis_results, {:foreign_key => 'TestCode'}, inverse_of: :praxis_test

	scope :current, lambda {where ("CurrentTest=1")}
end
