# == Schema Information
#
# Table name: clinical_assignments
#
#  student_id          :integer          not null
#  id                  :integer          not null, primary key
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  CourseID            :string(45)       not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#

class ClinicalAssignment < ActiveRecord::Base

	belongs_to :student
	belongs_to :clinical_teacher
	belongs_to :banner_term, {:foreign_key => 'Term'}

	validates :clinical_teacher_id,
		uniqueness: {
			scope: [:student_id, :CourseID, :Term],
			message: "Student may not be matched with same teacher more than once in the same course in the same semester."
		},
		presence: {message: "Please select a clinical teacher."}

	validates :student_id,
		:presence => {message: "Please select a student."}

	validate do |a|
		a.errors.add(:StartDate, "Please enter a valid start date.") unless a.StartDate.kind_of?(Date)
		a.errors.add(:EndDate, "Please enter a valid end date.") unless a.EndDate.kind_of?(Date)
		a.errors.add(:base, "Start date must be before end date.") if a.StartDate and a.EndDate and a.StartDate >= a.EndDate
		#purposly not validating for start and end dates to fall inside the term.	
	end

end
