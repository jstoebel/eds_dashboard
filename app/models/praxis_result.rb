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
	
	def score_check 
		# if test is passing return true; 
		# if test is not passing return false; 
		# if test has no score return nil;
		# if self.test_score 
		# 	return nil
		# if self.test_score 
			
		# 	return
		# if self.test_score
			
		# 	return
		# end
		if self.test_score.present?
			if self.test_score >= self.cut_score
				return true
			else self.test_score < self.cut_score
				return false
			end
		else
			return nil

		end
	end
	
	def passing?
		if self.test_score.blank? or self.cut_score.blank?
			return false
		else
			return self.test_score >= self.cut_score
		end
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
