# == Schema Information
#
# Table name: praxis_tests
#
#  id               :integer          not null, primary key
#  TestCode         :string(45)       not null
#  TestName         :string(255)
#  CutScore         :integer
#  TestFamily       :string(1)
#  Sub1             :string(255)
#  Sub2             :string(255)
#  Sub3             :string(255)
#  Sub4             :string(255)
#  Sub5             :string(255)
#  Sub6             :string(255)
#  Sub7             :string(255)
#  Program_ProgCode :integer
#  CurrentTest      :boolean
#
include Faker
FactoryGirl.define do
  factory :praxis_test do


    TestCode do
      codes = PraxisTest.all.pluck :TestCode
      while true do
        random_code =  Number.between(1,1000)
        break if !codes.include? random_code.to_s
      end
      random_code
    end
    TestName {Book.title}
    CutScore {Number.between(100, 200)}
    TestFamily 1
  end
end
