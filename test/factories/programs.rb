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

FactoryGirl.define do
  factory :program do
    sequence(:ProgCode) { |n| n}
    EPSBProgName "EPSB Name"
    EDSProgName "EDS Name"
    Current true
  end
end
