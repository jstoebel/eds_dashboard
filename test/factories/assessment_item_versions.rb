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

# Read about factories at https://github.com/thoughtbot/factory_girl

=begin


=end

include Faker
FactoryGirl.define do
  factory :assessment_item_version do
    association :assessment_version, factory: :assessment_version
    association :assessment_item, factory: :assessment_item
    item_code {Number.hexadecimal(2)}
  end
end
