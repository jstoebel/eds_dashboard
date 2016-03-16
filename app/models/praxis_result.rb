class PraxisResult < ActiveRecord::Base

	self.primary_keys = :Bnum, :TestCode, :TestDate
	belongs_to :student, {:foreign_key => "Bnum"}
	has_many :praxis_subtest_results
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
