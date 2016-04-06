class PraxisResult < ActiveRecord::Base

	#callbacks
	after_validation :set_id
	before_validation :check_alterability
	before_destroy :check_alterability

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


	def can_alter?
		#if this test record may be altered.
		#if a score has been recorded for this record, it can't be changed.
		return true if self.id.blank?
		db_record = PraxisResult.find(self.id)
		return db_record.test_score.blank?
	end


	private

	def set_id
		#set the id if all validations pass.
		if self.errors.size == 0
			self.id = [self.student_id, self.praxis_test_id, self.test_date.to_s].join("-")
		end
	end

	def check_alterability
		if !self.can_alter?
			self.errors.add(:base, "Test has scores and may not be altered.")
			return false
		end
		return true
	end

end
