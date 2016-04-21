class ProgExit < ActiveRecord::Base

	#RELATIONSHIPS
	belongs_to :student
	belongs_to :program, foreign_key: "Program_ProgCode"
	belongs_to :exit_code, foreign_key: "ExitCode_ExitCode"
	belongs_to :banner_term, foreign_key: "ExitTerm"

	#CALLBACKS
	before_validation :add_term

	after_save :change_status

	#SCOPES
	scope :by_term, ->(term) {where("ExitTerm = ?", term)}

	#ADVANCED VALIDATIONS
	validate :if => :check_basics do |e|
		#GPA must be 2.5 or 3.0 in last 60 credit hours.
		e.errors.add(:base, "Student must have 2.5 GPA or 3.0 in the last 60 credit hours.") if (e.GPA < 2.5 and e.GPA_last60 < 3.0) 
		
		#recommend date must be >= exit date
		e.errors.add(:RecommendDate, "Student may not be recommended for certification before exiting program.") if e.RecommendDate.present? && e.ExitDate > e.RecommendDate
		
		#can only have a recommend date if student completed program

		e.errors.add(:RecommendDate, "Student may not be recommended for certificaiton unless they have sucessfully completed the program.") if e.RecommendDate.present? and e.ExitCode_ExitCode != "1849"

		#TODO Can't be recomended without passing Praxis II
			#need to know which program each PraxisII exam belongs to.

		#Can't be recommended without graduating with EDS with certification
			#The best I can do right now is make sure student has graduated.
			#TODO Make sure the student graduated with a certification major
		e.errors.add(:ExitCode_ExitCode, "Student must have graduated in order to complete their program.") if e.ExitCode_ExitCode == '1849' and e.student.EnrollmentStatus != 'Graduation'

		#security validations. Won't come up in typical user experience.
		check_open if e.new_record?		#if record is new, let's make sure that we are closing an open program

	end

	def AltID
		return self.id
	end

	private

	def check_basics
		#checks the presence of foreign keys before running more advanced validations.

	    self.errors.add(:Student_Bnum, "Please select a student.") if self.Student_Bnum.blank?
	    self.errors.add(:Program_ProgCode, "Please select a program.") if self.Program_ProgCode.blank?
	    self.errors.add(:ExitCode_ExitCode, "Please select an exit code.") if self.ExitCode_ExitCode.blank?
	    self.errors.add(:ExitTerm, "No exit term could be determined.") if self.ExitTerm.blank?

	    if self.errors.size == 0
	      return true
	    else
	      return false
	    end
	end

	def check_open

		#ensures that
			#1) exiting student was accepted to this program
			#2) exiting student has not exited this program already.

		stu = self.student

		admission = AdmTep.where(Student_Bnum: stu.Bnum).where(Program_ProgCode: self.Program_ProgCode).where(TEPAdmit: true)
		exits = ProgExit.where(Student_Bnum: stu.Bnum).where(Program_ProgCode: self.Program_ProgCode)

		if admission.size == 0
			self.errors.add(:Program_ProgCode, "Student was never admitted to this program.")
		end

		if exits.size > 0
			self.errors.add(:Program_ProgCode, "Student has already exited this program.")
		end
	end
		

	def add_term
		#adds the banner term to record based on date.

		if self.ExitDate
			term = ApplicationController.helpers.current_term({:date => self.ExitDate})
			if term
				self.ExitTerm = term.BannerTerm
			else
				#add error to object
				self.errors.add(:ExitDate, "Exit date out of range.")
			end

		end
	end

	def change_status
		#program completion -> student becomes a completer
		#non complete exit -> student becomes dropped if they have no unexited programs
		
		stu = self.student
		
		if self.ExitCode_ExitCode == "1849"
			
			stu.ProgStatus = "Completer"
			stu.save

		elsif stu.ProgStatus == "Candidate"		#exit wasn't completion

			if AdmTep.open(stu.Bnum).size == 0
				#no open programs left after save
				stu.ProgStatus = "Dropped"
				stu.save
				
			end	
		end

	end

end
