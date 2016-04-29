# == Schema Information
#
# Table name: praxis_prep
#
#  student_id          :integer          not null
#  TestID              :integer          not null, primary key
#  PraxisTest_TestCode :integer          not null
#  Sub1Name            :string(45)
#  Sub1Score           :float(24)
#  Sub2Name            :string(45)
#  Sub2Score           :float(24)
#  Sub3Name            :string(45)
#  Sub3Score           :float(24)
#  Sub4Name            :string(45)
#  Sub4Score           :float(24)
#  Sub5Name            :string(45)
#  Sub5Score           :float(24)
#  Sub6Name            :string(45)
#  Sub6Score           :float(24)
#  Sub7Name            :string(45)
#  Sub7Score           :float(24)
#  TestScore           :float(24)
#  RemediationRequired :boolean
#  RemediationComplete :boolean
#  Notes               :text(2147483647)
#
# Indexes
#
#  fk_PraxisPrep_PraxisTest1_idx  (PraxisTest_TestCode)
#  praxis_prep_student_id_fk      (student_id)
#

require 'test_helper'

class PraxisPrepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
