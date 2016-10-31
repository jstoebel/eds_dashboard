# == Schema Information
#
# Table name: clinical_teachers
#
#  id                  :integer          not null, primary key
#  Bnum                :string(45)
#  FirstName           :string(45)       not null
#  LastName            :string(45)       not null
#  Email               :string(45)
#  Subject             :string(45)
#  clinical_site_id    :integer          not null
#  Rank                :integer
#  YearsExp            :integer
#  begin_service       :datetime
#  epsb_training       :datetime
#  ct_record           :datetime
#  co_teacher_training :datetime
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
    begin_service { Faker::Date.between(10.years.ago, Date.today) }
    epsb_training { Faker::Date.between(10.years.ago, Date.today) }
    ct_record { Faker::Date.between(10.years.ago, Date.today) }
    co_teacher_training { Faker::Date.between(10.years.ago, Date.today) }
  end
end
