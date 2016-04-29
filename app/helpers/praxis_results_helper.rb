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
#  pass           :boolean
#
# Indexes
#
#  fk_praxis_results_praxis_tests_idx  (praxis_test_id)
#  fk_praxis_results_students_idx      (student_id)
#  index_by_stu_test_date              (student_id,praxis_test_id,test_date) UNIQUE
#

module PraxisResultsHelper
end
