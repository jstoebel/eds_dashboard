# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)      not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

include Faker
FactoryGirl.define do
  factory :assessment do
    name {Lorem.words(4).join " "}
    slug {Lorem.words(4).join " "}
    description {Lorem.paragraph}
    factory :assessment_with_scores do

      after(:create) do |assessment|
        FactoryGirl.create :item_with_scores, {
          :assessment => assessment
        }
      end

    end
  end
end
