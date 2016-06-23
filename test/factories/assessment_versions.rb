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
    association :assessment    #should provide the assessment_id
    association :version_hatm_items
    version_num {}       #should be based upon created at?
  end
end
