class PraxisResult < ActiveRecord::Base

	self.primary_keys = :Bnum, :TestCode, :TestDate
	belongs_to :student
	has_many :praxis_subtest_results
	belongs_to :praxis_test

	validates :student_id,
		presence: {message: "Please select a student."}

	validates :test_code,
		presence: {message: "Test must be selected."}

	validates :test_date,
		presence: {message: "Test date must be selected."}

	validates :reg_date,
		presence: {message: "Registration date must be selected."}

	validates :paid_by,
		presence: {message: "Payment source must be given."},
		inclusion: {
			:in => ['EDS', 'ETS (fee waiver)', 'Student'],
			message: "Invalid payment source.",
			allow_blank: true}	

end
