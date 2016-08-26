# == Schema Information
#
# Table name: praxis_results
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  praxis_test_id :integer
#  test_date      :datetime
#  reg_date       :datetime
#  paid_by        :string(255)
#  test_score     :integer
#  best_score     :integer
#  cut_score      :integer
#

FactoryGirl.define do
  factory :praxis_result do
    association :student
    association :praxis_test
    test_date Date.today
    reg_date Date.today
    test_score 100
    best_score 100
    paid_by "EDS"

    after(:create) { |result| FactoryGirl.create_list :praxis_subtest_result, 4, {:praxis_result_id => result.id}}

  end
end
