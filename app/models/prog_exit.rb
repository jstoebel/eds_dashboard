class ProgExit < ActiveRecord::Base


	belongs_to :student, foreign_key: "Student_Bnum"
	belongs_to :program, foreign_key: "Program_ProgCode"
	belongs_to :exit_code, foreign_key: "ExitCode_ExitCode"

	scope :by_term, ->(term) {where("ExitTerm = ?", term)}

	validates :Student_Bnum,
		:presence => {message: "Please select a student."} 

	validates :Program_ProgCode,
		:presence => {message: "Please select a program."}

	validates :ExitCode_ExitCode,
		:presence => {message: "Please select a reason for exiting."}

	validates :ExitDate,
		:presence => {message: "Please select an exit date."}

	validate do |exit|

		student = Student.where("AltID = ?", exit.Student_Bnum).first
		admitted_programs = student.adm_tep

		#GPA must be 2.5 or 3.0 in last 60 credit hours.
		exit.errors.add(:base, "Student must have 2.5 GPA or 3.0 in the last 60 credit hours.") unless (exit.GPA >= 2.5 or exit.GPA_last60 >= 3.0) 
		
		#recommend date must be >= exit date
		exit.errors.add(:RecommendDate, "Student may not be recommended for certification before exiting program.") unless (exit.ExitCode_ExitCode == '1849' and exit.RecommendDate and exit.ExitDate <= exit.RecommendDate)
		
		#TODO Can't be recomended without passing Praxis II
			#need to know which program each PraxisII exam belongs to.



		#Can't be recommended without graduating with EDS with certification
			#The best I can do right now is make sure student has graduated.
			#TODO Make sure the student graduated with a certification major
		exit.errors.add(:RecommendDate, "Student must have graduated in order to be recommended for certification.") unless exit.ExitCode_ExitCode == '1849' and student.EnrollmentStatus == 'Graduation'

		#security validations. Won't come up in typical user experience.

		#make sure we are exiting a student from a program they are admitted to 
		exit.errors.add(:Program_ProgCode, "Student may not be exited from a program they have not been admitted to.") unless (admitted_programs.map {|p| p.Program_ProgCode}).include?(exit.Program_ProgCode)
	end

end
