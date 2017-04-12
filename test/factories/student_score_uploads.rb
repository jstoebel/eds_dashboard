# == Schema Information
#
# Table name: student_score_uploads
#
#  id         :integer          not null, primary key
#  source     :string(255)
#  success    :boolean
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :student_score_upload do
    
  end
end
