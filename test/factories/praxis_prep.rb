# == Schema Information
#
# Table name: praxis_prep
#
#  TestID              :integer          not null, primary key
#  student_id          :integer          not null
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

FactoryGirl.define do
  factory :praxis_prep do

    student
    
    #praxis_test needs to be passed in

    (1..7).each do |i|
        send("Sub#{i}Name", "Subtest#{i}") 
    end
    RemediationRequired true
    RemediationComplete true


  end 
end
