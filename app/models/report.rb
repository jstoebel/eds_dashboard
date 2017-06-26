class Report < ApplicationRecord
  # TODO
  has_many :students, {:foreign_key => 'Program_ProgCode', through: :adm_tep}
end
