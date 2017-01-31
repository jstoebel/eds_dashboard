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
#

FactoryGirl.define do |f|
  factory :praxis_result do
    association :student
    association :praxis_test
    test_date Date.today
    reg_date Date.today
    paid_by "EDS"

    after(:create) { |result| FactoryGirl.create_list :praxis_subtest_result, 4, {:praxis_result_id => result.id}}

    factory :passing_test do
      after(:create) do |passing_result|
        passing_result.test_score = (failing_result.cut_score) + 1
        passing_result.save({:validate => false})
      end
    end
    factory :failing_test do
      after(:create) do |failing_result|
        failing_result.test_score = (failing_result.cut_score) - 1
        failing_result.save({:validate => false})
      end
    end

  end
end
