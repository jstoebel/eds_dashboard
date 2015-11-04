class ProgExit < ActiveRecord::Base


	#RELATIONSHIPS
	belongs_to :student, foreign_key: "Student_Bnum"
	belongs_to :program, foreign_key: "Program_ProgCode"
	belongs_to :exit_code, foreign_key: "ExitCode_ExitCode"

	#CALLBACKS
	before_save :add_term

	after_save :change_status

	#SCOPES
	scope :by_term, ->(term) {where("ExitTerm = ?", term)}
	
	#VALIDATIONS
	BNUM_REGEX = /\AB00\d{6}\Z/i
	validates :Student_Bnum,
		:presence => {message: "Please select a student."},
		format: {with: BNUM_REGEX,
        message: "Please enter a valid B#, (including the B00)",
        allow_blank: true}

	validates :Program_ProgCode,
		:presence => {message: "Please select a program."}

	validates :ExitCode_ExitCode,
		:presence => {message: "Please select a reason for exiting."}


	validates :ExitDate,
		:presence => {message: "Please select an exit date."}
		


	validate do |e|

		#GPA must be 2.5 or 3.0 in last 60 credit hours.
		e.errors.add(:base, "Student must have 2.5 GPA or 3.0 in the last 60 credit hours.") unless (e.GPA >= 2.5 or e.GPA_last60 >= 3.0) 
		
		#recommend date must be >= exit date
		e.errors.add(:RecommendDate, "Student may not be recommended for certification before exiting program.") if  ( (e.RecommendDate != nil) and (e.ExitDate > e.RecommendDate) )
		
		#can only have a recommend date if student completed program

		e.errors.add(:RecommendDate, "Student may not be recommended for certificaiton unless they have sucessfully completed the program.") if ( (e.RecommendDate != nil) and (e.ExitCode_ExitCode != '1849') ) 


		#TODO Can't be recomended without passing Praxis II
			#need to know which program each PraxisII exam belongs to.



		#Can't be recommended without graduating with EDS with certification
			#The best I can do right now is make sure student has graduated.
			#TODO Make sure the student graduated with a certification major
		e.errors.add(:ExitReason, "Student must have graduated in order to complete their program.") if ( (e.ExitCode_ExitCode == '1849') and (student.EnrollmentStatus != 'Graduation'))

		#security validations. Won't come up in typical user experience.

		student = Student.where("Bnum = ?", e.Student_Bnum).first
		if student.kind_of?(Student) and e.Program_ProgCode != "" 	#only look for admitted programs if a student was found. If no student wasn't found this isn't a threat anyway.
			admitted_programs = student.adm_tep.admitted
			#make sure we are exiting a student from a program they are admitted to 
			e.errors.add(:Program_ProgCode, "Student may not be exited from a program they have not been admitted to.") unless ((admitted_programs.map {|p| p.Program_ProgCode}.include?(e.Program_ProgCode)))
		end

		#make sure that we are exiting from program that was open
	    stu = e.student
	    if stu
		    open_admissions = AdmTep.open(stu.Bnum)
		    open_programs = open_admissions.map { |i| i.program.ProgCode }

		    if e.new_record? and e.Program_ProgCode.to_s != "" and not open_programs.include?(e.Program_ProgCode)
	    		e.errors.add(:Program_ProgCode, "Student may not be exited from a program that they are not currently enrolled in.")
			end
		end

	end

	private
	def add_term
		if self.ExitDate
			term = ApplicationController.helpers.current_term({:date => self.ExitDate})
			self.ExitTerm = term.BannerTerm
		end
	end

	def change_status
		#program completion -> student becomes a completer
		#non complete exit -> student becomes dropped if they have no unexited programs
		
		stu = self.student


		if self.ExitCode_ExitCode == "1849"
			
			stu.ProgStatus = "Completer"
			stu.save

		else
			#exit was not a completion
			#mark student as dropped if no open programs left
			if AdmTep.open(stu.Bnum).size == 0
				#no open programs left after save
				stu.ProgStatus = "Dropped"
				stu.save
				
			end	
		end

	end


end
