# == Schema Information
#
# Table name: programs
#
#  id           :integer          not null, primary key
#  ProgCode     :string(10)       not null
#  EPSBProgName :string(100)
#  EDSProgName  :string(45)
#  Current      :boolean
#

FactoryGirl.define do
  factory :program do
    ProgCode "999"
    EPSBProgName "EPSB Name"
    EDSProgName "EDS Name"
    Current true
  end
end
