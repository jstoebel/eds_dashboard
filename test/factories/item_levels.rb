# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer
#  descriptor         :text(65535)
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#  passing            :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_level do
    assessment_item
    descriptor Lorem.paragraph
    level Lorem.word
    sequence(:ord, (1..4).cycle)

    factory :level_with_scores do

      after(:create) do |level|
        FactoryGirl.create :student_score, {
          :item_level => level
        }
      end

    end
  end
end
