# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text
#  level              :integer
#  created_at         :datetime
#  updated_at         :datetime
#
# Indexes
#
#  item_levels_assessment_item_id_fk  (assessment_item_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_level do
  end
end
