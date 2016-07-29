# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

include Faker
FactoryGirl.define do
  factory :assessment_version do
    assessment   #should provide the assessment_id
    
    factory :version_with_items do
      after(:create) do |version|
        version.assessment_items << FactoryGirl.create_list(:assessment_item, 4)  #items for versions
        version.assessment_items.each do |i|
          i.item_levels << FactoryGirl.create_list(:item_level, 4)    #levels for each item
        end
        version.assessment_items.each do |item|    #for each item
          num_scores = Faker::Number.between(0, 3)
          levels = item.item_levels.shuffle.slice(0, num_scores)
          levels.each do |l|
            l.student_scores << FactoryGirl.create(:student_score, {:assessment_item_id => item.id, :assessment_version_id => version.id})
          end
        end
        version.save
      end
    end
  end
end
