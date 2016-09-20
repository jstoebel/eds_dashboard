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

    factory :applying_foi, parent: :foi do
      seek_cert {true}
    end

    factory :not_applying_foi, parent: :foi do
      seek_cert {false}
      eds_only {Faker::Boolean.boolean(0.5)}
    end
  end
end
