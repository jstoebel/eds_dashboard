# == Schema Information
#
# Table name: dispositions
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :text(65535)
#  current     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

include Faker
FactoryGirl.define do
  factory :disposition do
    code {"#{Number.digit}.#{Number.digit}"}
    description {Hipster.sentence}
    current true
  end
end
