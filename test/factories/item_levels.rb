# == Schema Information
#
# Table name: item_levels
#
#  id                  :integer          not null, primary key
#  assessment_item_id  :integer
#  descriptor          :text(65535)
#  level               :string(255)
#  ord                 :integer
#  created_at          :datetime
#  updated_at          :datetime
#  passing             :boolean
#  descriptor_stripped :text(65535)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_level do
    assessment_item
    descriptor {Lorem.paragraph}
    level {Number.between(1,4)}
    sequence(:ord, (1..4).cycle)
    passing {Boolean.boolean 0.5}

    factory :level_with_scores do

      after(:create) do |level|
        FactoryGirl.create :student_score, {
          :item_level => level
        }
      end

    end
  end
end
