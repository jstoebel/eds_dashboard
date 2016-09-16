# == Schema Information
#
# Table name: forms_of_intention
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  date_completing :datetime
#  new_form        :boolean
#  major_id        :integer
#  seek_cert       :boolean
#  eds_only        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
  factory :foi do
    student
    date_completing Date.today
    new_form true
    major

    eds_only nil
    
    factory :applying_foi do
      seek_cert true
    end
    
    factory :not_apply_foi do
      seek_cert false
    end
  end
end