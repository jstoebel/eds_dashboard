class Student < ActiveRecord::Base
	include ApplicationHelper

	has_many :praxis_results, {:foreign_key => 'Bnum'}
	has_many :issues, {:foreign_key => 'students_Bnum'}

	has_many :adm_tep, {:foreign_key => 'Student_Bnum'}
	has_many :programs, {:foreign_key => 'Student_Bnum', through: :adm_tep}

	has_many :adm_st, {:foreign_key => 'Student_Bnum'}
	has_many :prog_exits, {:foreign_key => 'Student_Bnum'}
	has_many :clinical_assignments, {:foreign_key => 'Student_Bnum'}
	has_many :student_files, {:foreign_key => 'Student_Bnum'}

	has_many :advisor_assignments, {:foreign_key => 'Student_Bnum'}
	has_many :tep_advisors, {:foreign_key => 'Student_Bnum', :through => :advisor_assignments}

	has_many :transcripts, {:foreign_key => 'Student_Bnum'}

	scope :by_last, lambda {order(LastName: :asc)}
	scope :current, lambda { where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])}		#TODO also need to know if student is activly enrolled (see banner)
	scope :candidates, lambda {where("ProgStatus='Candidate' and EnrollmentStatus='Active Student'")}
	scope :from_alt_id, ->(alt_id) {where("AltID = ?", alt_id).first}		#finds a student based on AltID
	
	# scope :with_prof, ->(prof_bnum) {find(:all, 
	# 		joins: "LEFT JOIN advisor_assignments on advisor_assignments.Student_Bnum = students.Bnum
	# 		LEFT JOIN transcript on transcript.Student_Bnum = students.Bnum"
	# 		).where("tep_advisors_AdvisorBnum = ? or Inst_bnum = ?", prof_bnum, prof_bnum)

	# 	}

	def is_advisee_of(prof_bnum)
		#is this student advisee of the prof with prof_bnum?
		advisor_assignments = self.advisor_assignments
		bnums = advisor_assignments.map { |i| i.tep_advisors_AdvisorBnum }
		return bnums.include?(prof_bnum)
	end

	def is_student_of(prof_bnum)
		#does this student have this prof in the current term (plan_b = forward)
		term = current_term({:exact => false, :plan_b => :forward})
		classes = self.transcripts.in_term(term)
		profs = classes.map { |i| i.Inst_bnum }
		return profs.include?(prof_bnum)
	end

end
