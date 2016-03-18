class PraxisResult < ActiveRecord::Base

	#callbacks
	after_validation :set_id

	belongs_to :student
	has_many :praxis_subtest_results
	belongs_to :praxis_test

	validates :student_id,
		presence: {message: "Please select a student."}

	validates :praxis_test_id,
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

	private

	def set_id
		#set the id if all validations pass.
		if self.errors.size == 0
			self.id = [self.student_id, self.praxis_test_id, self.test_date.to_s].join("-")
		end
	end

end
