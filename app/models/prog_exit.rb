# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text(65535)
#

class ProgExit < ActiveRecord::Base

	#RELATIONSHIPS
	belongs_to :student
	belongs_to :program, foreign_key: "Program_ProgCode"
	belongs_to :exit_code, foreign_key: "ExitCode_ExitCode"
	belongs_to :banner_term, foreign_key: "ExitTerm"

	has_one :adm_tep, :through => :program
	#CALLBACKS
	before_validation :add_term, :set_gpas

	#SCOPES
	scope :by_term, ->(term) {where("ExitTerm = ?", term)}

	#ADVANCED VALIDATIONS
	validate :if => :check_basics do |e|
		#GPA must be 2.5 or 3.0 in last 60 credit hours.

		completer_code = ExitCode.find_by :ExitCode => "1849"

		e.errors.add(:base, "Student must have 2.5 GPA or 3.0 in the last 60 credit hours.") if !good_gpa?

		#recommend date must be >= exit date
		e.errors.add(:RecommendDate, "Student may not be recommended for certification before exiting program.") if e.RecommendDate.present? && e.ExitDate > e.RecommendDate

		#can only have a recommend date if student completed program

		e.errors.add(:RecommendDate, "Student may not be recommended for certificaiton unless they have sucessfully completed the program.") if e.RecommendDate.present? and e.ExitCode_ExitCode != completer_code.id

		#TODO Can't be recomended without passing Praxis II
			#need to know which program each PraxisII exam belongs to.

		#Can't be recommended without graduating with EDS with certification
			#The best I can do right now is make sure student has graduated.
			#TODO Make sure the student graduated with a certification major

		e.errors.add(:ExitCode_ExitCode, "Student must have graduated in order to complete their program.") if e.ExitCode_ExitCode == completer_code.id and e.student.EnrollmentStatus != 'Graduation'

		#security validations. Won't come up in typical user experience.
		check_admited if e.new_record?		#if record is new, let's make sure that we are closing an open program

	end

	def AltID
		return self.id
	end

	def good_gpa?
    return (self.GPA.andand >= 2.50 or self.GPA_last60.andand >= 3.0)
  end

	private

	def check_basics
		#checks the presence of foreign keys before running more advanced validations.

	    self.errors.add(:student_id, "Please select a student.") if self.student_id.blank?
	    self.errors.add(:Program_ProgCode, "Please select a program.") if self.Program_ProgCode.blank?
	    self.errors.add(:ExitCode_ExitCode, "Please select an exit code.") if self.ExitCode_ExitCode.blank?
	    self.errors.add(:ExitTerm, "No exit term could be determined.") if self.ExitTerm.blank?

	    if self.errors.size == 0
	      return true
	    else
	      return false
	    end
	end

	def check_admited
		#check that the student was admitted to this program

		stu = self.student
		admissions = stu.adm_tep
		program_ids = admissions.map { |adm| adm.program.id}

		if !program_ids.include? self.Program_ProgCode
			self.errors.add(:Program_ProgCode, "Student was never admitted to this program.")
		end
	end

	def add_term
		#adds the banner term to record based on date.

		if self.ExitDate.present?
			term = BannerTerm.current_term({:date => self.ExitDate, :exact => false, :plan_b => :back})
			if term
				self.ExitTerm = term.BannerTerm
			else
				#add error to object
				self.errors.add(:ExitDate, "Exit date out of range.")
			end
		end
	end

	def set_gpas
    #set GPAs for record

    if self.errors.blank? && self.student_id.present?
      stu = self.student

      self.GPA = stu.gpa({:term => self.ExitTerm})
      self.GPA_last60 = stu.gpa({:term => self.ExitTerm, :last => 60})
    end
  end

end
