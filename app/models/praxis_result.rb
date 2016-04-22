class PraxisResult < ActiveRecord::Base

	#callbacks
	before_validation :check_alterability
	before_validation :check_unique
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
		return true if self.new_record?
		db_record = PraxisResult.find(self.id)
		return db_record.test_score.blank?
	end

	def AltID
		return self.id
	end

	private

	def check_unique
		matching_ids = PraxisResult.where(
			student_id: self.student_id,
			praxis_test_id: self.praxis_test_id,
			test_date: self.test_date
			 )
		# puts "I found #{matching_ids.size} matching ids"
		if matching_ids.size > 1
			self.errors.add(:base, "Student may not take the same exam on the same day.")
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
