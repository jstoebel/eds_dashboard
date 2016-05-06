# == Schema Information
#
# Table name: clinical_teachers
#
#  id               :integer          not null, primary key
#  Bnum             :string(45)
#  FirstName        :string(45)       not null
#  LastName         :string(45)       not null
#  Email            :string(45)
#  Subject          :string(45)
#  clinical_site_id :integer          not null
#  Rank             :integer
#  YearsExp         :integer
#

include Faker
FactoryGirl.define do
  factory :clinical_teacher do
    Bnum {"B00#{Number.number(6)}"}
    FirstName {Name.first_name}
    LastName {Name.last_name}
    Email {Internet.email}
    Subject {Hipster.word}
    clinical_site
    Rank {Number.between(1,3)}
    YearsExp {Number.between(1, 25)}
  end
end
