class ClinicalAssignment < ActiveRecord::Base

	belongs_to :student, {:foreign_key => 'Bnum'}
	belongs_to :clinical_teacher

	validates :id,
		uniqueness: {message: "Student may not be matched with same teacher more than once in the same course in the same semester."}

	validates :Bnum,
		:presence => {message: "Please select a student."}

  	validates :clinical_teacher_id,
  		:presence => {message: "Please select a clinical teacher."}

	validate do |a|
		a.errors.add(:StartDate, "Please enter a valid start date.") unless a.StartDate.kind_of?(Date)
		a.errors.add(:EndDate, "Please enter a valid end date.") unless a.EndDate.kind_of?(Date)
		a.errors.add(:base, "Start date must be before end date.") if a.StartDate and a.EndDate and a.StartDate >= a.EndDate
	end

end
