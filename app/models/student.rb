class Student < ActiveRecord::Base
	include ApplicationHelper

	has_many :praxis_results
	
	has_many :issues
	has_many :issue_updates

	has_many :adm_tep
	has_many :programs

	has_many :adm_st
	has_many :prog_exits
	has_many :clinical_assignments
	has_many :student_files

	has_many :advisor_assignments
	has_many :tep_advisors

	has_many :transcripts
	has_many :foi


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
	   	passings = PraxisResult.where(student_id: self.Bnum, pass: 1).map{ |p| p.praxis_test_id}

	   	req_tests.each do |requirement|
	   		if not passings.include? requirement
	   			return false	#found a required test student hasn't passed
   			end

	   	end

	   	return true		#failed to find a required test student hasn't passed.
	end

	# AltID was removed. The arbitrary unique identifier is now id (its also the pk).
	# This method prevents us from having to refactor
	def AltID
		return self.id
	end

	def prog_status
		#Program Statuses
		# Prospective
		# 	A student who has registered for EDS150 and has not indicated they WON'T apply to the TEP.
		# 	No admit found in TEP
		# 	FOI does not incidate that the student IS NOT seeking certification 

		# Not applying:
		# 	A student who has indicated they are not interested in applying to the TEP.
		# 	FOI indicates they are not interested in certification

		# Candidate
		# 	A student who has applied to the TEP, was admitted and is still persuing certification.
		# 	Admited in adm_tep
		# 	no exit


		# Dropped
		# 	A student who has left the TEP after being admited for any reason other than program completion
		# 	Admited in adm_tep
		# 	all adm_tep are closed
		#   all exit reasons something other than program completion 

		# Completer
		# 	A student who has successfully completed the TEP.
		# 	Admited in adm_tep
		# 	all adm_tep are closed
		#   atleast one exit is for reason program completion

		




	end

end
