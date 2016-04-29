# == Schema Information
#
# Table name: assessment_item_versions
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  item_code             :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#
# Indexes
#
#  assessment_item_versions_assessment_item_id_fk     (assessment_item_id)
#  assessment_item_versions_assessment_version_id_fk  (assessment_version_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assessment_item_version do
  end
end
