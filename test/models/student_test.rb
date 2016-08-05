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
#  CurrentMinors    :string(45)
#  Email            :string(100)
#  CPO              :string(45)
#  withdrawals      :text
#  term_graduated   :integer
#  gender           :string(255)
#  race             :string(255)
#  hispanic         :boolean
#  term_expl_major  :integer
#  term_major       :integer
#

require 'test_helper'
require 'minitest/autorun'
require 'factory_girl'
class StudentTest < ActiveSupport::TestCase

	let(:stu) {FactoryGirl.create :student}

	test "by_last scope" do

		expected = Student.all.order(LastName: :asc)
		actual = Student.by_last
		assert_equal(expected.slice(0, expected.size), actual.slice(0, actual.size))
	end

	test "active_student" do
		expected = Student.where(:EnrollmentStatus => "Active Student")
		actual = Student.active_student
		assert_equal(expected.to_a, actual.to_a)
	end

	test "current scope" do
		#tests the scope called current
		expected = Student.select {|s| ["Candidate", "Prospective"].include?(s.prog_status) }
		actual = Student.current
		assert_equal(expected.slice(0, expected.size), actual.slice(0, actual.size))

	end

	test "candidates scope" do
		expected = Student.select {|s| ["Candidate"].include?(s.prog_status) }
		actual = Student.candidates
		assert_equal(expected.slice(0, expected.size), actual.slice(0, actual.size))
	end

	test "is advisee of passes" do
		assignment = AdvisorAssignment.first
		s = assignment.student
		adv = assignment.tep_advisor
		assert s.is_advisee_of(adv)
	end

	test "is advisee of fails" do
		assignment = AdvisorAssignment.first
		s = assignment.student
		adv = assignment.tep_advisor
		assert (s.is_advisee_of("bad bnum") == false)
	end

	test "is student of passes" do
		term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :forward})

		#update course with the term that the model expects in order to pass
		course = Transcript.first
		course.term_taken = term.BannerTerm
		assert course.valid?
		course.save

		stu = course.student
		prof_bnum = course.inst_bnums[0]
		assert stu.is_student_of?(prof_bnum), "inst B# is " + prof_bnum
	end

	test "is student of fails bad term" do
		#fails because student doesn't have professor in the current term

		course = Transcript.first
		course.term_taken = 195301
		assert course.valid?
		course.save
		stu = course.student
		prof_bnum = course.instructors
		assert stu.is_student_of?(prof_bnum) == false
	end

	test "is student of fails not student" do

		term = ApplicationController.helpers.current_term({:exact => false, :plan_b => :forward})

		#fails because student doesn't have this prof (in fact the Bnum is completly bogus)
		course = Transcript.first
		course.term_taken = term.BannerTerm
		assert course.valid?
		course.save

		stu = course.student
		prof_bnum = course.instructors
		assert stu.is_student_of?("bogus bnum") == false
	end

	test "praxisI_pass" do
		Student.all.each do |stu|
		   	req_tests = PraxisTest.where(TestFamily: 1, CurrentTest: 1).map{ |t| t.TestCode}
		   	all_passed = stu.praxis_results.select { |pr| pr.passing?}.map{ |p| p.praxis_test_id}
		   	passing = true

		   	req_tests.each do |requirement|
		   		if not all_passed.include? requirement
		   			passing = false
	   			end
		   	end

			assert_equal stu.praxisI_pass, passing
		end
	end

	test "latest_foi" do
		stu = Foi.first.student
		assert_equal stu.foi.order(:date_completing).last, stu.latest_foi
	end

	test "was_dismissed" do
		stu = Student.first
		stu.EnrollmentStatus = "Dismissed - Academic"
		stu.save
		assert stu.was_dismissed?
	end

	test "was_dismissed false" do
		stu = Student.first
		stu.EnrollmentStatus = "Active Student"
		stu.save
		assert_not stu.was_dismissed?
	end

	test "returns prospective no foi" do
		Foi.delete_all
		AdmTep.delete_all
		s = Student.first
		s.EnrollmentStatus = "Active Student"
		s.save
		assert_equal "Prospective", s.prog_status
	end

	test "should not return perspective - enrollmentstatus graduated" do
		Foi.delete_all
		AdmTep.delete_all
		s = Student.first
		s.EnrollmentStatus = "Graduated"
		s.save
		assert_equal "Dropped", s.prog_status
	end

	test "should not return perspective - enrollmentstatus transfered" do
		Foi.delete_all
		AdmTep.delete_all
		s = Student.first
		s.EnrollmentStatus = "WD-Transferring"
		s.save
		assert_equal "Dropped", s.prog_status
	end



	test "returns prospective positive foi" do
		stu = Student.first

		#remove all FOIs and adm_tep
		form = Foi.first
		Foi.delete_all
		AdmTep.delete_all
		form.seek_cert = true
		form.student_id = stu.id
		form.save

		stu.EnrollmentStatus = "Active Student"
		stu.save

		assert_equal "Prospective", stu.prog_status
	end

	test "returns not applying foi" do
		stu = Student.first

		#remove all FOIs and adm_tep
		form = Foi.first
		Foi.delete_all
		AdmTep.delete_all

		form.seek_cert = true
		form.student_id = stu.id
		form.save

		stu.EnrollmentStatus = "Active Student"
		stu.save

		assert_equal "Prospective", stu.prog_status

	end

	test "returns not applying dismissed" do
		stu = Student.first
		Foi.delete_all

		stu.EnrollmentStatus = "Dismissed - Academic"
		stu.save
		assert_equal "Not applying", stu.prog_status
	end

	test "returns candidate" do
		ProgExit.delete_all
		app = AdmTep.find_by :TEPAdmit => true
		assert_equal "Candidate", app.student.prog_status
	end

	test "returns dropped" do

		my_exit = ProgExit.first
		stu = my_exit.student

		#delete all exits and start over
		ProgExit.delete_all

		#get the code for exit
		drop_exit = ExitCode.find_by :ExitCode => "1809"

		#create a new exit that isn't a completion
		my_exit.ExitCode_ExitCode = drop_exit.id
		my_exit.RecommendDate = nil
		new_exit = ProgExit.new my_exit.attributes

		#make sure the new
		assert new_exit.save, new_exit.errors.full_messages

		assert_equal "Dropped", stu.prog_status

	end

	test "returns completer" do
		completer_code = ExitCode.find_by :ExitCode => "1849"
		my_exit = ProgExit.find_by :ExitCode_ExitCode => completer_code.id
		stu = my_exit.student
		assert_equal "Completer", stu.prog_status
	end

	test "returns completer with one drop" do
		completer_code = ExitCode.find_by :ExitCode => "1849"
		my_exit = ProgExit.find_by :ExitCode_ExitCode => completer_code.id
		stu = my_exit.student
		pop_praxisI stu, true		#make student pass the praxis
		old_app = my_exit.adm_tep

		#create a second admission
		second_program = Program.where.not(:id => my_exit.ExitCode_ExitCode).first
		second_adm = AdmTep.new old_app.attributes
		second_adm.Program_ProgCode = second_program.id
		second_adm.id = nil
		attach_letter second_adm

		#make transcript for student
		# (stu, n, grade_pt, term)
		pop_transcript(stu, 12, 3.0, second_adm.banner_term.prev_term)

		assert second_adm.save, second_adm.errors.full_messages

	end

	test "open_programs" do
		stu = Student.first
		apps = stu.adm_tep.where(:TEPAdmit => true)
		expected = apps.select { |a| ProgExit.find_by({:student_id => a.student_id, :Program_ProgCode => a.Program_ProgCode}) == nil }

		assert_equal expected.to_a, stu.open_programs.to_a
	end

	test "gpa with no options" do
		courses = FactoryGirl.create_list(:transcript, 4, {
				term_taken: BannerTerm.first.id,
				grade_pt: 4.0
			})

		stu = courses[0].student
		assert_equal 4.0, stu.gpa
	end

	test "gpa with term limit" do


		first_course = FactoryGirl.create :transcript, {
			term_taken: BannerTerm.first.id,
			grade_pt: 4.0
		}

		stu = first_course.student

		BannerTerm.all.slice(1,2).map {|term| FactoryGirl.create :transcript, {
				student_id: stu.id,
				term_taken: term.id,
				grade_pt: 3.0
			}}

		assert 4.0, stu.gpa({term: first_course.term_taken})
	end

	test "gpa with credit limit" do
		first_course = FactoryGirl.create :transcript, {
			term_taken: BannerTerm.first.id,
			grade_pt: 4.0
		}

		stu = first_course.student

		second_course = FactoryGirl.create :transcript, {
			term_taken: BannerTerm.second.id,
			student_id: stu.id,
			grade_pt: 3.0
		}

		assert_equal 3.0, stu.gpa({last: second_course.credits_earned})
	end


	it "updates last_name table" do
		stu.LastName = "new-name"
		stu.save
		expect LastName.where(student_id: stu.id).size.must_equal 2

	end


	describe "eds_major" do
		describe "from major" do

			let(:major_student){FactoryGirl.create :student, {:CurrentMajor1 => "Education Studies"}}

			it "to major" do
				major_student.CurrentMajor1 = "Education Studies"
				assert major_student.was_eds_major?
				assert major_student.is_eds_major?
			end

			it "to non major" do
				major_student.CurrentMajor1 = "English"
				assert major_student.was_eds_major?
				assert_not major_student.is_eds_major?
			end
		end

		let(:non_major){FactoryGirl.create :student, {:CurrentMajor1 => "English"}}

		describe "from non major" do
			it "to non major" do
				non_major.CurrentMajor1 = "English"
				assert_not non_major.was_eds_major?
				assert_not non_major.is_eds_major?
			end

			it "to major" do
				non_major.CurrentMajor1 = "Education Studies"
				assert_not non_major.was_eds_major?
				assert non_major.is_eds_major?
			end

		end

	end

	describe "cert_concentration" do
		let(:cert_student){FactoryGirl.create :student, {:concentration1 => "Middle Grades Science Cert"}}

		describe "from cert" do
			it "to cert" do
				cert_student.concentration1 = "Middle Grades Science Cert"
				assert cert_student.was_cert_concentration?
				assert cert_student.is_cert_concentration?
			end

			it "to non cert" do
				cert_student.concentration1 = "nope"
				assert cert_student.was_cert_concentration?
				assert_not cert_student.is_cert_concentration?
			end
		end

		describe "from non cert" do
			let(:non_cert_student){FactoryGirl.create :student, {:concentration1 => "something else"}}

			it "to non cert" do
				non_cert_student.concentration1 = "nope"
				assert_not non_cert_student.was_cert_concentration?
				assert_not non_cert_student.is_cert_concentration?
			end

			it "to cert" do
				non_cert_student.concentration1 = "Middle Grades Science Cert"
				assert_not non_cert_student.was_cert_concentration?
				assert non_cert_student.is_cert_concentration?
			end
		end
	end

	let(:students){
		[
	        {
	            "Bnum"=> "B00999992",
	            "FirstName"=> "Joe",
	            "MiddleName"=> "J",
	            "LastName"=> "Joseph",
	            "EnrollmentStatus"=>"Active Student",
	            "Classification"=> "Senior",
	            "CurrentMajor1"=> "Education Studies",
	            "concentration1"=> "Elementary",
	            "CurrentMajor2"=> "English",
	            "concentration2"=> "Literature",
	            "CurrentMinors"=> "spamspamspam",
	            "Email"=>"josephj@berea.edu",
	            "CPO"=>"123",
	            "withdraws"=>"eggs; bakedbeans",
	            "term_graduated"=> 201611,
	            "gender"=> "Male",
	            "race"=> "none of your bussiness",
	            "hispanic"=> true,
	            "term_expl_major"=> 201411,
	            "term_major"=> 201511
	        },

	        {
	            "Bnum"=> "B00999991",
	            "FirstName"=> "Jacob",
	            "MiddleName"=> "B",
	            "LastName"=> "Stoebel",
	            "EnrollmentStatus"=>"Active Student",
	            "Classification"=> "Senior",
	            "CurrentMajor1"=> "Education Studies",
	            "concentration1"=> "Elementary",
	            "CurrentMajor2"=> "English",
	            "concentration2"=> "Literature",
	            "CurrentMinors"=> "spamspamspam",
	            "Email"=>"stoebelj@berea.edu",
	            "CPO"=>"123",
	            "withdraws"=>"eggs; bakedbeans",
	            "term_graduated"=> 201611,
	            "gender"=> "Male",
	            "race"=> "none of your bussiness",
	            "hispanic"=> true,
	            "term_expl_major"=> 201411,
	            "term_major"=> 201511
	        }

		]}

	it "batch uploads students" do
		s0 = Student.all.size
		Student.batch_create(students)
		s1 = Student.all.size
		expect (s1-s0).must_equal(2)
	end

	it "does not batch upload students" do
		#try to submit the same data twice. We should end up with two new records (not four)

		s0 = Student.all.size
		2.times {|i| Student.batch_create(students)}
		s1 = Student.all.size
		expect (s1-s0).must_equal(2)
	end

	it "batch updates students" do
		#create 2 students
		stus = FactoryGirl.create_list :student, 2
		update_attrs = stus.map{|s| {:id => s.id, :CurrentMajor1 => "new major"}}
		Student.batch_update(update_attrs)

		#both students should have changed their major
		assert update_attrs.map{ |attr| Student.find(attr[:id]).CurrentMajor1  == "new major"}.all?

	end

	it "does not batch update students failed validation" do
		#make a validation fail

		#create 2 students
		stus = FactoryGirl.create_list :student, 2
		update_attrs = stus.map{|s| {:id => s.id, :EnrollmentStatus => nil}}


		result = Student.batch_update(update_attrs)
		assert_equal false, result[:success]
		assert_equal "Validation failed: Enrollmentstatus can't be blank", result[:msg]

	end

	it "does not batch update students can't find record" do
		stus = FactoryGirl.create_list :student, 1
		update_attrs = stus.map{|s| {:id => "blah", :CurrentMajor1 => "new major"}}
		result = Student.batch_update(update_attrs)
		assert_equal false, result[:success]
		assert_equal "Couldn't find Student with 'id'=#{update_attrs[0][:id]}", result[:msg]
	end

    test "Object not valid, validations failed" do
	  stu=Student.new
	  assert_not stu.valid?
	  assert_equal [:Bnum, :FirstName, :LastName, :EnrollmentStatus], stu.errors.keys
	  assert_equal [:Bnum, :FirstName, :LastName, :EnrollmentStatus].map{|i| [i, ["can't be blank"]]}.to_h,
	    stu.errors.messages
	end
end
