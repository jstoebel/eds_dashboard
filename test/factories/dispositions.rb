# == Schema Information
#
# Table name: dispositions
#
#  id               :integer          not null, primary key
#  disp_code        :string(255)
#  disp_description :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

include Faker
FactoryGirl.define do
  factory :disposition do
    disp_code {"#{Number.digit}.#{Number.digit}"}
    disp_description {Hipster.sentence}
  end
end
