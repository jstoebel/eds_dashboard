class PraxisTest < ActiveRecord::Base

	has_many :praxis_results
    belongs_to :program, :foreign_key => "Program_ProgCode"


	scope :current, lambda {where ("CurrentTest=1")}
end
