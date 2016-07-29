# == Schema Information
#
# Table name: version_habtm_items
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#


FactoryGirl.define do
  factory :version_habtm_item do
    assessment_version
    assessment_item
  end
end
