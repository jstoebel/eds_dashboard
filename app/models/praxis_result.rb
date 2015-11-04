class PraxisResult < ActiveRecord::Base

	belongs_to :student
	has_many :praxis_subtest_results, {:foreign_key => 'praxis_results_TestID'}
	belongs_to :praxis_test



	validate do |pr|
		pr.errors.add(:base, "Name must be selected.") if pr.Bnum.blank?	
		pr.errors.add(:base, "Test must be selected.") if pr.TestCode.blank?
		pr.errors.add(:base, "Test Date must be given.") if pr.TestDate.blank?
		pr.errors.add(:base, "Registration Date must be given.") if pr.RegDate.blank?
		pr.errors.add(:base, "Payment source must be given.") if pr.PaidBy.blank?

	end
end
