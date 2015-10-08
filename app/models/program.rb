class Program < ActiveRecord::Base
	has_many :adm_tep, {:foreign_key => 'Program_ProgCode'}
	has_many :students, {:foreign_key => 'Program_ProgCode', through: :adm_tep}

	has_many :prog_exits, {:foreign_key => 'Program_ProgCode'}

	scope :open, ->(bnum) {where("") }	#all unexited programs for a student

end
