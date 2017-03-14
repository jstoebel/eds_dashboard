# == Schema Information
#
# Table name: assessment_items
#
#  id            :integer          not null, primary key
#  assessment_id :integer
#  name          :string(255)
#  slug          :string(255)
#  description   :text(65535)
#  created_at    :datetime
#  updated_at    :datetime
#  start_term    :integer
#  end_term      :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl
include Faker

FactoryGirl.define do
  factory :assessment_item do
    assessment
    slug {Lorem.words(4).join " "}  #Lazy load, calls every time executed
    name {Lorem.words(5).join " "}
    description {Lorem.paragraph}

    factory :item_with_scores do
      after(:create) do |item|
        FactoryGirl.create :level_with_scores, {
          :assessment_item => item
        }

      end

    end
  end

end
