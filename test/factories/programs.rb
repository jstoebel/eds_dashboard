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
    ProgCode do
      codes = Program.all.pluck :ProgCode
      while true
        code = Number.between(1, 999)
        break if !codes.include? code
      end
      code
    end
    EPSBProgName "EPSB Name"
    EDSProgName "EDS Name"
    Current true
  end
end
