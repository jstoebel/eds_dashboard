class Report < ActiveRecord::Base
	has_many :students, {:foreign_key => 'Program_ProgCode', through: :adm_tep}
end
