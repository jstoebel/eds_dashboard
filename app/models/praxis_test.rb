class PraxisTest < ActiveRecord::Base

	has_many :praxis_results


	scope :current, lambda {where ("CurrentTest=1")}
end
