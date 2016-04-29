# == Schema Information
#
# Table name: students
#
#  id               :integer          not null, primary key
#  Bnum             :string(9)        not null
#  FirstName        :string(45)       not null
#  PreferredFirst   :string(45)
#  MiddleName       :string(45)
#  LastName         :string(45)       not null
#  PrevLast         :string(45)
#  ProgStatus       :string(45)       default("Prospective")
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  CurrentMajor2    :string(45)
#  TermMajor        :integer
#  PraxisICohort    :string(45)
#  PraxisIICohort   :string(45)
#  CellPhone        :string(45)
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#
# Indexes
#
#  Bnum_UNIQUE  (Bnum) UNIQUE
#

class Student < ActiveRecord::Base
	include ApplicationHelper

	has_many :praxis_results
	
	has_many :issues
	has_many :issue_updates

	has_many :adm_tep
	has_many :programs, :through => :adm_tep

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
	
	def is_advisee_of(advisor_profile)
		#is this student advisee of the prof with prof_bnum?
		adv_assigns = self.advisor_assignments	#students advisor assignments
		my_advisors = self.advisor_assignments.map { |a| a.tep_advisor }
		return my_advisors.include?(advisor_profile)
	end

	def is_student_of?(inst_bnum)
		#does this student have this prof in the current term (plan_b = forward)

		term = BannerTerm.current_term({:exact => false, :plan_b => :forward})
		classes = self.transcripts.in_term(term)
		my_profs = classes.map { |i| i.Inst_bnum }
		return my_profs.include?(inst_bnum) 
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

	def open_programs
		admited = AdmTep.where(:student_id => self.id, :TEPAdmit => true)

		return admited.select { |a| ProgExit.find_by({:student_id => a.student_id, :Program_ProgCode => a.Program_ProgCode}) == nil }
	end

	def prog_status
		#Program Statuses
		# Prospective: all of the following conditions are met.

		#   * student has not been dismissed AND
		#	* latest FOI does not incidate that the student IS NOT seeking certification AND
		# 	* No admit in adm_tep 

		if 	(not self.was_dismissed?) and 
			(self.latest_foi == nil or self.latest_foi.seek_cert) and
			(self.adm_tep.where(:TEPAdmit => true).size == 0)

			return "Prospective"


		# Not applying: any of the following
		# 	A student who has indicated they are not interested in applying to the TEP. OR
		# 	A student who was dismissed from the college and never aditted to TEP
		elsif 	(self.latest_foi.present? and not self.latest_foi.seek_cert) or
				(self.was_dismissed?)
			return "Not applying"

		# Candidate
		# 	Admited in adm_tep
		# 	no exit
		elsif self.open_programs.size > 0
			return "Candidate"

		# Dropped
		# 	A student who has left the TEP after being admited for any reason other than program completion
		# 	Admited in adm_tep
		# 	all adm_tep are closed
		#   all exit reasons something other than program completion 

		elsif 	(self.open_programs.size == 0) and
				(self.prog_exits.map{ |e| e.exit_code.ExitCode != "1849" }.all?)

			return "Dropped"

		# Completer
		# 	A student who has successfully completed the TEP.
		# 	all adm_tep are closed
		#   atleast one exit is for reason program completion
		elsif 	(AdmTep.open(self.id).size == 0) and
				(self.prog_exits.map{ |e| e.exit_code.ExitCode == "1849" }.any?)

			return "Completer"

		else
			return "Unknown Status"
		end


	end

	def was_dismissed?
		return self.EnrollmentStatus.include?("Dismissed")
	end

	def latest_foi
		#the most recent form of intention for this student
		return Foi.where({:student_id => self.id}).order(:date_completing).last
	end


end
