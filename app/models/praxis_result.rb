class PraxisResult < ActiveRecord::Base

	belongs_to :student
	has_many :praxis_subtest_results, {:foreign_key => 'praxis_results_TestID'}
	belongs_to :praxis_test, {:foreign_key => 'TestCode'}

	validates :Bnum,
		presence: {message: "Please select a student."}

	validates :TestCode,
		presence: {message: "Test must be selected."}

	validates :TestDate,
		presence: {message: "Test date must be selected."}

	validates :RegDate,
		presence: {message: "Registration date must be selected."}

	validates :PaidBy,
		presence: {message: "Payment source must be given."},
		inclusion: {
			:in => ['EDS', 'ETS (fee waiver)', 'Student'],
			message: "Invalid payment source.",
			allow_blank: true}	

end
