# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_level do
    assessment_item
    descriptor Lorem.paragraph
    level Lorem.word
    ord Number.between(1, 4)
    
    # factory :item_level_with_scores do
    #   transient do
    #     student_score_count 3
    #   end
    #   after(:create) do |level, enumerator|
    #     create_list(:student_score, evaluator.student_score_count, item_levels: [level])
    #   end
    # end
  end
end
