# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  version_num   :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

include Faker
FactoryGirl.define do
  factory :assessment_version do
    assessment   #should provide the assessment_id
    
    #create associated items
    factory :version_with_items do
      after(:create) do |ver|
        ver.assessment_item << FactoryGirl.create(:assessment_item)
        FactoryGirl.create_list(:item_level, {:assessment_item_id => ver.assessment_item.id}, 3)
      end
    end
  end
=begin #each level, associate associated item with version
    levels.each do |r|
      factory r do
        items = after(:create) {|version| AssessmentItem.find(r.assessment_item_id)    #find items created above
        items
        
        
        (:assessment_version, assessment_items: [assessment_item])
        factory :workout_with_exercises do
      after(:create) do |workout|
        FactoryGirl.create(:exercise, workout: workout)    #skeptical of this line
  end
=end
end