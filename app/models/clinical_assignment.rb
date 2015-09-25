class ClinicalAssignment < ActiveRecord::Base

	belongs_to :student, {:foreign_key => 'Bnum'}
	belongs_to :clinical_teacher

	validates :Bnum,
		:presence => {message: "Please select a student."}

  	validates :clinical_teacher_id,
  		:presence => {message: "Please select a clinical teacher."}


	#date must be inside term
	#

	validate do |a|
		a.errors.add(:StartDate, "Please enter a valid start date.") unless a.StartDate.kind_of?(Date)
		a.errors.add(:EndDate, "Please enter a valid end date.") unless a.EndDate.kind_of?(Date)
	end

	private
	def valid_date(date_str)
		#returns if date_str is a valid date using format mm/dd/yyyy
		begin
			date = Date.strftime(date_str, '%m/%d/%Y')
			return true
		rescue ArgumentError => e
			return false
			
		end
	end

end
