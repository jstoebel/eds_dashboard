# == Schema Information
#
# Table name: praxis_result_temps
#
#  id             :integer          not null, primary key
#  first_name     :string(255)
#  last_name      :string(255)
#  student_id     :integer
#  praxis_test_id :integer
#  test_date      :datetime
#  test_score     :integer
#  best_score     :integer
#


include Faker
FactoryGirl.define do
  factory :praxis_result_temp do
    first_name {Name.first_name}
    last_name {Name.last_name}
    student_id {nil}
    association :praxis_test
    test_date {Date.today}
    test_score {Number.between(100, 200)}
    best_score {Number.between(100, 200)}

    after(:create) do |result|
      (1..4).each do |n|
        FactoryGirl.create :praxis_sub_temp, {:sub_number => n,
          :praxis_result_temp => result}
      end
    end

  end
end
