class Program < ActiveRecord::Base
	has_many :adm_tep, {:foreign_key => 'Program_ProgCode'}
	has_many :prog_exits, {:foreign_key => 'Program_ProgCode'}
end
