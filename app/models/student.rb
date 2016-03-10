class Student < ActiveRecord::Base
	include ApplicationHelper

	has_many :praxis_results, {:foreign_key => 'Bnum'}
	
	has_many :issues, {:foreign_key => 'students_Bnum'}
	has_many :issue_updates, {:foreign_key => 'students_Bnum', through: :issues}

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
	scope :current, lambda { where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])}
	scope :candidates, lambda {where("ProgStatus='Candidate' and EnrollmentStatus='Active Student'")}
	
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

	def praxisI_pass
	   	#input a Student instance
	   	#output if student has passed all praxis I exams.
   	
	   	req_tests = PraxisTest.where(TestFamily: 1, CurrentTest: 1).map{ |t| t.TestCode}
	   	passings = PraxisResult.where(Bnum: self.Bnum, Pass: 1).map{ |p| p.TestCode}

	   	req_tests.each do |requirement|
	   		if not passings.include? requirement
	   			return false	#found a required test student hasn't passed
   			end

	   	end

	   	return true		#failed to find a required test student hasn't passed.
	end

end
