class ProgExit < ActiveRecord::Base


	belongs_to :student, foreign_key: "Student_Bnum"
	belongs_to :program, foreign_key: "Program_ProgCode"
	belongs_to :exit_code, foreign_key: "ExitCode_ExitCode"


	scope :by_term, ->(term) {where("ExitTerm = ?", term)}

	validate do |exit|
		#TODO student can't successfully complete without 2.5 or 3.0 in last 60 hours
		
		#security validations. Won't come up in typical user experience.
		admitted_programs = exit.student.adm_tep
		#make sure we are exiting a student from a program they are admitted to 
		exit.errors.add(:Program_ProgCode, "Student may not be exited from a program they have not been admitted to.") unless admitted_programs.map {|p| p.Program_ProgCode}
	end

end
