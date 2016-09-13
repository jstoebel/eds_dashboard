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
#  EnrollmentStatus :string(45)
#  Classification   :string(45)
#  CurrentMajor1    :string(45)
#  concentration1   :string(255)
#  CurrentMajor2    :string(45)
#  concentration2   :string(255)
#  CellPhone        :string(45)
#  CurrentMinors    :string(255)
#  Email            :string(100)
#  CPO              :string(45)
#  withdraws        :text(65535)
#  term_graduated   :integer
#  gender           :string(255)
#  race             :string(255)
#  hispanic         :boolean
#  term_expl_major  :integer
#  term_major       :integer
#

class Student < ActiveRecord::Base
	include ApplicationHelper

####~~~ASSOCIATIONS without Model Methods~~~####################################################

	has_many :issues
	has_many :issue_updates

	has_many :adm_st
	has_many :clinical_assignments
	has_many :student_files

	has_many :adm_tep
	has_many :programs, :through => :adm_tep

	has_many :advisor_assignments
	has_many :tep_advisors, :through => :advisor_assignments

  has_many :student_scores

  has_many :pgps

	has_many :praxis_results
	has_many :praxis_prep
	has_many :praxis_result_temps
###################################################################################################


####~~~HOOKS~~~##################################################
	after_save :process_last_name

#################################################################


####~~~VALIDATIONS~~~##################################################
	validates_presence_of :Bnum, :FirstName, :LastName, :EnrollmentStatus
	validates_uniqueness_of :Bnum

#######################################################################



####~~~ CLASS VARIABLES ~~~##################################################
	CERT_CONCENTRATIONS = ["Middle Grades Science Cert",
	"MUS Ed - Instrumental Emphasis",
	"MUS Ed - Vocal Emphasis",
	"Elementary P-5",
	"Teaching & Curr with Cert",
	"General Curriculum",
	"Education Studies General Cur",
	"Teaching & Curriculum",
	"Elementary, P-5",
	"Middle Grades Math",
	"Middle Grades Science",
	"Music Education Instrumental Emphasis",
	"Music Education Vocal Emphasis",
	"Health and Human Performance, P-12"]

##############################################################################



####~~~SCOPES AND CLASS METHODS (Batch Updates)~~~##################################################

	scope :by_last, lambda {order(LastName: :asc)}
	scope :active_student, lambda {where(:EnrollmentStatus => "Active Student")}
	scope :current, lambda {select {|s| ["Candidate", "Prospective"].include?(s.prog_status) }}
	scope :candidates, lambda {select {|s| ["Candidate"].include?(s.prog_status) }}


	# TODO: add support for searching through previous last names
	# scope :with_name, ->(name) {where("FirstName=? or PreferredFirst=? or LastName=?", name, name, name)}

	def self.with_name(str)
		# str(string): the query string
		# return an arel query where any of the following match any word in string
			# FirstName
			# LastName
			# PrefFirst
			# any last_name in the last_names table

			# typical useage:
			# qry = Student.with_name("Jacob")
			# stus = Student.joins(:last_names).where(qry)

		words = str.split(" ")
		students_tbl = Student.arel_table
		last_names_tbl = LastName.arel_table
		query = students_tbl[:FirstName].in(words).or(
			students_tbl[:LastName].in(words)).or(
			students_tbl[:PreferredFirst].in(words)
			).or(last_names_tbl[:last_name].in(words))

		return query
	end

	def self.batch_create(hashes)
		#bulk inserts student records
		# hashes: array of hashes each containing params
		# returns hash of results reporting success and a message

		begin
			Student.transaction do
				hashes.each do |stu_hash|
					Student.create! stu_hash
				end #loop
			end #transaction
		rescue ActiveRecord::RecordInvalid => msg
			#some record couldn't be saved
			return {:success => false, :msg => msg.to_s}
		end #exception handle
		return {:success => true, :msg => "Successfully inserted #{hashes.size} records."}

	end

	def self.batch_update(hashes)
		#bulk updates student records
		# hashes: array of hashes each containing params
		# returns hash of results reporting success and a message

		begin
			Student.transaction do
				hashes.each do |stu_hash|
					s = Student.find stu_hash[:id]
					#need to throw out id. Don't change that!
					s.update_attributes! stu_hash.reject{|k,v| k == :id}
				end 	# loop
			end # transaction
		rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => msg #also need to catch if Record not found
			return {:success => false, :msg => msg.to_s}
		end #exception handle
		return {:success => true, :msg => "Successfully updated #{hashes.size} records."}
	end

###########################################################################################



####~~~Model Methods with Associations~~~##################################################



	####~~~Praxis Associations and Methods~~~##############################################

	def praxisI_pass
	   	#output if student has passed all praxis I exams.

	   	req_tests = PraxisTest.where(TestFamily: 1, CurrentTest: 1).map{ |t| t.id}
	   	passings = self.praxis_results.select { |pr| pr.passing? }.map{ |p| p.praxis_test_id}
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
	#####################################################################################


	####~~~Student Name assoc. and Methods~~~############################################
	has_many :last_names

	def name_readable(file_as = false)
    #returns full student name with additional first and last names as needed
    #if file_as, return student with last name first (Fee, Jon)

		first_name = self.PreferredFirst.present? ? self.PreferredFirst + " (#{self.FirstName})" : self.FirstName
		last_name = self.PrevLast.present? ? last_name = self.LastName + " (#{self.PrevLast})" : self.LastName

	    if file_as
	      return [last_name+',', first_name].join(' ')  #return last name first
	    else
	      return [first_name, last_name].join(' ')  #return first name first
    	end
	end
	######################################################################################


	####~~~AdmTep Associations and Methods~~~#############################################

	def open_programs
		admited = AdmTep.where(:student_id => self.id, :TEPAdmit => true)
		return admited.select { |a| ProgExit.find_by({:student_id => a.student_id, :Program_ProgCode => a.Program_ProgCode}) == nil }
	end
	#######################################################################################



	####~~~FOI associations and methods~~~#################################################

	has_many :foi
	has_many :prog_exits

	def prog_status
		#Program Statuses
		# Prospective: all of the following conditions are met.

		#   * student has not been dismissed AND
		#	* latest FOI does not incidate that the student IS NOT seeking certification AND
		# 	* No admit in adm_tep
		enrollment = [(not self.was_dismissed?),
			(self.latest_foi == nil or self.latest_foi.seek_cert),
			(self.adm_tep.where(:TEPAdmit => true).size == 0),
			(not graduated), (not transfered)]

		if enrollment.all?

			return "Prospective"


		#Add that student has not graduated
		#Use enrollment status var
		#Also if they have transfered
		#graduated? or transferred? possible var names to create and use
		#create methods for graduated and wd-transferring


		# Not applying: any of the following
		# 	A student who has indicated they are not interested in applying to the TEP. OR
		# 	A student who was dismissed from the college and never admitted to TEP
		elsif 	(self.latest_foi.present? and not self.latest_foi.seek_cert) or
				(self.was_dismissed?) or
				graduated or transfered
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
		return self.EnrollmentStatus.andand.include?("Dismissed").present?
	end

	def latest_foi
		#the most recent form of intention for this student
		return Foi.where({:student_id => self.id}).order(:date_completing).last
	end

	#######################################################################################



	#####~~~Transcripts and associations~~~################################################
	has_many :transcripts

	def credits(last_term=nil)
		#last_term: latest term_id to use in total (optional)
		credits = 0
		courses = self.transcripts.where("credits_earned is not null")
		courses.where!("term_taken <= ?", last_term) if last_term.present?
		courses.each do |t|
			credits += t.credits_earned
		end

		return credits
	end

	########################################################################################



####~~~ INSTANCE METHODS without Associations~~~##################################################

    ####~~~Advisee of Advisor Method~~~##################################################
	def is_advisee_of(advisor_profile)
		#is this student advisee of the prof with prof_bnum?
		adv_assigns = self.advisor_assignments	#students advisor assignments
		my_advisors = self.advisor_assignments.map { |a| a.tep_advisor }
		return my_advisors.include?(advisor_profile)
	end
	########################################################################################


	####~~~Student of Professor Method~~~##################################################

	def is_student_of?(inst_bnum)
		# if student has any current student/instructor relatilonship with this instructor
		return self.is_present_student_of?(inst_bnum) ||
			self.is_recent_student_of?(inst_bnum) ||
			self.will_be_student_of?(inst_bnum) ||
			self.has_incomplete_with?(inst_bnum)
	end

	def is_present_student_of?(inst_bnum)
		# inst_bnum: string: instructor B#
		# returns if a student is currently a student of this instructor.

		term = BannerTerm.current_term({:exact => true})
		if term.nil?
			return false
		else
			classes = self.transcripts.in_term(term)
			my_profs = classes.map{|c| c.inst_bnums}.flatten
			return my_profs.include?(inst_bnum)
		end
	end

	def is_recent_student_of?(inst_bnum)
		# inst_bnum: string: instructor B#
		# if between terms and student had this instructor in this term that just passed
		if BannerTerm.current_term(:exact => true).nil?
			term = BannerTerm.current_term({:exact => false, :plan_b => :back})
			classes = self.transcripts.in_term(term)
			my_profs = classes.map{|c| c.inst_bnums}.flatten
			return my_profs.include?(inst_bnum)
		else
			return false
		end
	end

	def will_be_student_of?(inst_bnum)
		# inst_bnum: string: instructor B#
		# if between terms and student will have this insructor in term coming up
		if BannerTerm.current_term(:exact => true).nil?
			term = BannerTerm.current_term({:exact => false, :plan_b => :forward})
			classes = self.transcripts.in_term(term)
			my_profs = classes.map{|c| c.inst_bnums}.flatten
			return my_profs.include?(inst_bnum)
		else
			return false
		end

	end

	def has_incomplete_with?(inst_bnum)
		# inst_bnum: string: instructor B#
		# if student has an incomplete in a course with this instructor

		incompletes = self.transcripts.where(:grade_ltr => "I")
		incomplete_profs = incompletes.map{|c| c.inst_bnums}.flatten
		return incomplete_profs.include?(inst_bnum)

	end

	########################################################################################



	####~~~GPA Method~~~######################################################

	def gpa(options={})
		#pre:
			#last: last number of credits to include in calculation
			# term: the id of the upper bound of terms to search
			#if nil examine all courses
		#post: returns gpa

	    defaults = {
			last: nil,	#(integer) if given, how many credits back should be included? Otherwise, use all
			term: nil	#(term id) the upper bound term to use. Otherwise, use all.
	    }

    options = defaults.merge(options)

		# filter out courses with no posted grade and order with most recent first then with most valuable courses first
		courses = self.transcripts.where("grade_ltr is not null").order(term_taken: :desc).order!(quality_points: :desc)

		#filter by term if one is given
		courses = courses.where("term_taken <= ?", options[:term]) if options[:term]

		# These two counters use the multiply by 4 system typical of most universities
		# credits in the Berea system are 1/4th of this typical value (typical course
		# is worth 1.0 credits

		credits = 0
		qpoints = 0

		courses.each do |course|

			if course.credits_attempted.present? and
				course.quality_points.present? and
				Transcript.standard_grades.include? course.grade_ltr

					# standard courses
					credits += course.credits_attempted * 4
					qpoints += course.quality_points * 4

			elsif course.grade_ltr == "CA"
				# convo credit: 1 converted credit, 4.0 converted quality_points

				credits += 1.0
				qpoints += 4.0
			end

			break if options[:last].present? && credits >= options[:last]
		end

		gpa_raw = qpoints / credits
		return (gpa_raw * 100).to_i / 100.0

	end

	#methods for is/was eds_major/cert_concentration

	["is", "was"].each do |pre|

		suffix = pre=="was" ? "_was" : ""
		define_method("#{pre}_eds_major?") do
			majors = (1..2).map{|i| self.send("CurrentMajor#{i}#{suffix}")}
			return majors.include?("Education Studies")
		end

		define_method("#{pre}_cert_concentration?") do
			my_concentrations_2d = [self.send("concentration1#{suffix}").andand.split(";"), self.send("concentration2#{suffix}").andand.split(";")]
			my_concentrations = my_concentrations_2d.flatten.select{|i| i.present?}
			my_concentrations.andand.each do |c|
				if CERT_CONCENTRATIONS.include?(c)
					return true
				end
			end
			return false
		end

	end

	##########################################################################



	####~~~Enrollment Methods~~~##############################################

	def graduated
		self.EnrollmentStatus == "Graduated"
	end

	def transfered
		self.EnrollmentStatus == "WD-Transferring"
	end

	##########################################################################



############################################################################################################

	private
	def process_last_name
		#create a new entry in last names table with current last name
		if self.LastName_changed?
			LastName.create({student_id: self.id, last_name: self.LastName})
		end
	end

end

############################################################################################################
