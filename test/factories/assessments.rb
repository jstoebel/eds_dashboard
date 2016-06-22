# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

include Faker
FactoryGirl.define do
  factory :assessment do
    name {Lorem.words(4).join " "}
    description {Lorem.paragraph}
  end
end
