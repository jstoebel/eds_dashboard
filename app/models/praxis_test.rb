# == Schema Information
#
# Table name: praxis_tests
#
#  id               :integer          not null, primary key
#  TestCode         :string(45)       not null
#  TestName         :string(45)
#  CutScore         :integer
#  TestFamily       :string(1)
#  Sub1             :string(100)
#  Sub2             :string(100)
#  Sub3             :string(100)
#  Sub4             :string(100)
#  Sub5             :string(100)
#  Sub6             :string(100)
#  Sub7             :string(45)
#  Program_ProgCode :integer          not null
#  CurrentTest      :boolean
#
# Indexes
#
#  TestCode_UNIQUE             (TestCode) UNIQUE
#  fk_PraxisTest_Program1_idx  (Program_ProgCode)
#

class PraxisTest < ActiveRecord::Base

	has_many :praxis_results
    belongs_to :program, :foreign_key => "Program_ProgCode"


	scope :current, lambda {where ("CurrentTest=1")}
end
