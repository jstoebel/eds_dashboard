# == Schema Information
#
# Table name: clinical_sites
#
#  id           :integer          not null, primary key
#  SiteName     :string(45)       not null
#  City         :string(45)
#  County       :string(45)
#  Principal    :string(45)
#  District     :string(45)
#  phone        :string(255)
#  receptionist :string(255)
#  website      :string(255)
#  email        :string(255)
#

include Faker
FactoryGirl.define do
  factory :clinical_site do
    SiteName {"#{StarWars.character} School"}
    City {Address.city}
    County {"#{StarWars.planet} County"}
    Principal {"#{Faker::Name.name}"}
    District {"#{StarWars.specie} School District"}
    phone {PhoneNumber.cell_phone}
    receptionist {Faker::Name.name}
    website {Internet.url}
    email {Internet.email}
  end
end
