# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  name        :string
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl
include Faker

FactoryGirl.define do
  factory :assessment_item do
    slug {Lorem.words(4).join " "}  #Lazy load, calls every time executed
    name {Lorem.words(5).join " "}
    description {Lorem.paragraph}
  end
end
