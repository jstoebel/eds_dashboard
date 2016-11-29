# == Schema Information
#
# Table name: programs
#
#  id           :integer          not null, primary key
#  ProgCode     :string(10)       not null
#  EPSBProgName :string(100)
#  EDSProgName  :string(45)
#  Current      :boolean
#  license_code :string(255)
#

include Faker
FactoryGirl.define do
  factory :program do
    sequence(:ProgCode){|n| n.to_s }
    EPSBProgName "EPSB Name"
    EDSProgName "EDS Name"
    Current true
  end
end
