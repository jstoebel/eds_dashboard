# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  version_num   :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

include Faker
FactoryGirl.define do
  factory :assessment_version do
    assessment   #should provide the assessment_id
    
    factory :version_with_items do
      # transient do
      #   item_count 2
      # end
      after(:create) do |version|
        version.assessment_items << FactoryGirl.create_list(:assessment_item, 4)  #items for versions
        
        version.assessment_items.each do |i|
          i.item_levels << FactoryGirl.create_list(:item_level, 4)    #levels for each item
        end
        version.assessment_items.each do |j|    #for each item
          num_scores = Faker::Number.between(0, 3)
          levels = j.item_levels.shuffle.slice(0, num_scores)
          levels.each do |l|
            l.student_scores << FactoryGirl.create(:student_score, {:assessment_item_id => l.assessment_item.id, :assessment_version_id => version.id})
          end
        end
        version.save
      end
    end
  end
end
    
    #factory :version_with_items do
      #create associated items and their levels
      #transient do
        #assessment_items_count 3
      #end
   
      #after(:create) do |version, evaluator|
        #create_list(:assessment_item_with_levels, evaluator.assessment_items_count, assessment_versions: [version])