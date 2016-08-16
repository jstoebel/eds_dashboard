require 'test_helper'

class ProcessStudentServiceTest < ActiveSupport::TestCase

  setup do
    ActionMailer::Base.deliveries.clear
    @row_template = {
      "SZVEDSD_ID" => nil,
      "SZVEDSD_LAST_NAME" => nil,
      "SZVEDSD_FIRST_NAME" => nil,
      "SZVEDSD_MIDDLE_NAME" => nil,
      "SZVEDSD_ENROLL_STAT" => nil,
      "SZVEDSD_CLASSIFICATION" => nil,
      "SZVEDSD_WITHDRAWALS" => nil,
      "SZVEDSD_TERM_GRADUATED" => nil,
      "SZVEDSD_GENDER" => nil,
      "SZVEDSD_SSN" => nil,
      "SZVEDSD_DOB" => nil,
      "SZVEDSD_RACE" => nil,
      "SZVEDSD_HISPANIC" => nil,
      "SZVEDSD_STATE" => nil,
      "SZVEDSD_COUNTY" => nil,
      "SZVEDSD_CITIZENSHIP" => nil,
      "SZVEDSD_COUNTRY_ORIGIN" => nil,
      "SZVEDSD_ESL" => nil,
      "SZVEDSD_COMPUTER_TOEFL" => nil,
      "SZVEDSD_TOEFL" => nil,
      "SZVEDSD_TOEFL_ESSAY" => nil,
      "SZVEDSD_TOEFL_LISTENING" => nil,
      "SZVEDSD_TOEFL_READING" => nil,
      "SZVEDSD_TOEFL_SPEAKING" => nil,
      "SZVEDSD_TOEFL_STRUCT_WRITING" => nil,
      "SZVEDSD_TOEFL_TOTAL" => nil,
      "SZVEDSD_TOEFL_WRITING" => nil,
      "SZVEDSD_TEST_WRITTEN_ENGLISH" => nil,
      "SZVEDSD_IELTS_LISTENING" => nil,
      "SZVEDSD_IELTS_READING" => nil,
      "SZVEDSD_IELTS_WRITING" => nil,
      "SZVEDSD_IELTS_SPEAKING" => nil,
      "SZVEDSD_IELTS_BAND_SCORE" => nil,
      "SZVEDSD_TRANSFER_STUDENT" => nil,
      "SZVEDSD_TERM_EDS_EXPLOR_MJR" => nil,
      "SZVEDSD_TERM_DECLARED_EDS_MJR" => nil,
      "SZVEDSD_PRIMARY_MAJOR" => nil,
      "SZVEDSD_PRIMARY_MAJOR_CONC" => nil,
      "SZVEDSD_SECONDARY_MAJOR" => nil,
      "SZVEDSD_SECONDARY_MAJOR_CONC" => nil,
      "SZVEDSD_ADVISOR" => nil,
      "SZVEDSD_HIGH_SCHOOL_GPA UMBER" => nil,
      "SZVEDSD_HIGH_SCHOLL_RANK UMBER" => nil,
      "SZVEDSD_ACT_ENGLISH" => nil,
      "SZVEDSD_ACT_MATH" => nil,
      "SZVEDSD_ACT_READING" => nil,
      "SZVEDSD_ACT_SCIENCE_REASONING" => nil,
      "SZVEDSD_ACT_COMPOSITE" => nil,
      "SZVEDSD_SAT_VERB_CRIT_READING" => nil,
      "SZVEDSD_SAT_MATH" => nil,
      "SZVEDSD_SAT_WRITING" => nil,
      "SZVEDSD_TERM_TAKEN" => nil,
      "SZVEDSD_CRN" => nil,
      "SZVEDSD_COURSE" => nil,
      "SZVEDSD_GRADE" => nil,
      "SZVEDSD_REGISTRATION_STAT" => nil,
      "SZVEDSD_CREDITS_ATTEMPTED" => nil,
      "SZVEDSD_CREDITS_EARNED" => nil,
      "SZVEDSD_MINORS" => nil,
      "SZVEDSD_GPA_IND" => nil,
      "SZVEDSD_EMAIL" => nil,
      "SZVEDSD_CPO" => nil,
      "SZVEDSD_FILTER_TERM" => nil,
      "SAVEDSD_INSTRUCTOR" =>nil
      }

  end

  ###TESTS FOR UPSERT###
  describe "upsert_student" do
    it "creates a new student" do

      stu_count0 = Student.all.size
      new_stu = FactoryGirl.attributes_for :student

      new_attrs = {
        "SZVEDSD_ID" => new_stu[:Bnum],
        "SZVEDSD_LAST_NAME" => new_stu[:LastName],
        "SZVEDSD_FIRST_NAME" => new_stu[:FirstName],
        "SZVEDSD_ENROLL_STAT" => "Active Student",
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      row_service.upsert_student

      expect Student.all.size == stu_count0 + 1

      stu = Student.find_by :Bnum => new_stu[:Bnum]
      filter_attrs = [:Bnum, :LastName, :FirstName, :EnrollmentStatus]

      #created student and student found in DB should match across these params
      assert_equal  new_attrs.slice(*filter_attrs), stu.attributes.slice(*filter_attrs)

    end

    it "updates a student" do

      stu_count0 = Student.all.size
      new_stu = FactoryGirl.create :student

      new_attrs = {
        "SZVEDSD_ID" => new_stu[:Bnum],
        "SZVEDSD_LAST_NAME" => new_stu[:LastName] + "!!!!",
        "SZVEDSD_FIRST_NAME" => new_stu[:FirstName],
        "SZVEDSD_ENROLL_STAT" => "Active Student",
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      row_service.upsert_student

      expect Student.all.size == stu_count0

      stu = Student.find_by :Bnum => new_stu[:Bnum]
      filter_attrs = [:LastName]

      #created student and student found in DB should match across these params
      assert_equal  new_attrs.slice(*filter_attrs), stu.attributes.slice(*filter_attrs)

    end

    it "does not upsert student, throws exception" do

      row_service = ProcessStudent.new @row_template  # passing in empy row
      assert_raises(ActiveRecord::RecordInvalid) {row_service.upsert_student}

    end

    describe "detects dropping out of program" do

      before do
        @stu = FactoryGirl.create :admitted_student
        @adv = FactoryGirl.create :tep_advisor
        FactoryGirl.create :advisor_assignment, {:student_id => @stu.id,
          :tep_advisor_id => @adv.id
        }

        @drop_attrs = @row_template.merge({
          "SZVEDSD_ID" => @stu[:Bnum],
          "SZVEDSD_LAST_NAME" => @stu[:LastName],
          "SZVEDSD_FIRST_NAME" => @stu[:FirstName],
          "SZVEDSD_ENROLL_STAT" => @stu[:EnrollmentStatus],
        })

      end

      it "detectes dropped major" do
        # need an EDS major who is admitted to the TEP

        @stu.update_attributes({:CurrentMajor1 => "Education Studies"})  #start off as EDS major

        row_service = ProcessStudent.new @drop_attrs
        row_service.upsert_student

        assert_equal 1, @stu.tep_advisors.size
        adv_email = ActionMailer::Base.deliveries.last

        assert_equal [@adv.get_email],  adv_email.to
        assert_equal [SECRET["APP_EMAIL_ADDRESS"]], adv_email.from
        assert_equal "Possible TEP status change for #{@stu.name_readable}", adv_email.subject
      end

      it "detectes dropped concentration" do
        # need an EDS major who is admitted to the TEP

        @stu.update_attributes({:concentration1 => "Middle Grades Science Cert"})

        row_service = ProcessStudent.new @drop_attrs
        row_service.upsert_student

        assert_equal 1, @stu.tep_advisors.size
        adv_email = ActionMailer::Base.deliveries.last

        assert_equal [@adv.get_email],  adv_email.to
        assert_equal [SECRET["APP_EMAIL_ADDRESS"]], adv_email.from
        assert_equal "Possible TEP status change for #{@stu.name_readable}", adv_email.subject
      end

    end

  end

  ###TESTS FOR UPSERT ADVISOR_ASSIGNMENTS###

  describe "update_advisors" do

    before do
      @stu = FactoryGirl.create :student
      @advisors = FactoryGirl.create_list :tep_advisor, 2

    end

    it "adds advisors" do
      adv_str = @advisors.map{ |a| "#{a.first_name} #{a.last_name} {Primary-#{a.AdvisorBnum}}" }.join("; ")

      new_attrs = {
        "SZVEDSD_ID" => @stu.Bnum,
        'SZVEDSD_ADVISOR' => adv_str
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      row_service.update_advisor_assignments

      assert_equal @stu.advisor_assignments.size, @advisors.size

      advisor_emails = ActionMailer::Base.deliveries
      assert_equal advisor_emails.size, @advisors.size

      #asertions for each advisor
      @advisors.each_with_index do |adv, i|
        assert @stu.is_advisee_of adv
        adv_email = advisor_emails[i]
        assert_equal [adv.get_email],  adv_email.to
        assert_equal [SECRET["APP_EMAIL_ADDRESS"]], adv_email.from
        assert_equal "Advisee status change for #{@stu.name_readable}", adv_email.subject
      end

    end

    it "removes all advisors" do

      # assign advisors to stu


      @advisors.each{|adv| AdvisorAssignment.create!({
          :student_id => @stu.id,
          :tep_advisor_id => adv.id
        })}

      new_attrs = {
        "SZVEDSD_ID" => @stu.Bnum
      } # no advisors!

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      row_service.update_advisor_assignments



      assert_equal @stu.advisor_assignments.size, 0

      # advisor_emails = ActionMailer::Base.deliveries

      # assertions for each advisor
      # assert_equal advisor_emails.size, @advisors.size
      @advisors.each_with_index do |adv, i|
        assert_not @stu.is_advisee_of adv
        # adv_email = advisor_emails[i]
        # assert_equal [adv.get_email],  adv_email.to
        # assert_equal [SECRET["APP_EMAIL_ADDRESS"]], adv_email.from
        # assert_equal "Advisee status change for #{@stu.name_readable}", adv_email.subject
      end

    end

    it "doesn't create assignment - throws StatementInvalid" do

      adv_str = @advisors.map{ |a| "#{a.first_name} #{a.last_name} {Primary-#{a.AdvisorBnum}}" }.join("; ")

      new_attrs = {
        "SZVEDSD_ID" => nil,
        'SZVEDSD_ADVISOR' => adv_str
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      assert_raises(ActiveRecord::StatementInvalid){row_service.update_advisor_assignments}
    end

    it "doesn't create assignment - throws StatementInvalid" do

      adv_str = @advisors.map{ |a| "#{a.first_name} #{a.last_name} {Primary-#{a.AdvisorBnum}}" }.join("; ")

      new_attrs = {
        "SZVEDSD_ID" => nil,
        'SZVEDSD_ADVISOR' => adv_str
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      assert_raises(ActiveRecord::StatementInvalid){row_service.update_advisor_assignments}
    end

  end

  ###TESTS FOR UPSERT COURSE

  describe "upsert_transcript" do

    before do
      @course = FactoryGirl.build :transcript, {:grade_ltr => 'C', :grade_pt => 2.0}
      term = BannerTerm.find @course[:term_taken]
      new_attrs={
        'SZVEDSD_ID' => @course.student.Bnum,
        'SZVEDSD_TERM_TAKEN' => "#{term.id} - #{term.PlainTerm}",
        'SZVEDSD_COURSE' => "#{@course[:course_code].insert(3, " ")} - #{@course[:course_name]}",
        'SZVEDSD_GRADE' => @course[:grade_ltr],
        'SZVEDSD_CRN' => @course[:crn],
        'SZVEDSD_CREDITS_ATTEMPTED' => @course[:credits_attempted],
        'SZVEDSD_CREDITS_EARNED' => @course[:credits_earned],
        'SZVEDSD_REGISTRATION_STAT' => @course[:reg_status],
        'SAVEDSD_INSTRUCTOR' => @course[:instructors],
        'SZVEDSD_GPA_IND' => @course[:gpa_include] ? "Include" : "Exclude"
      }

      @inter_row = @row_template.merge new_attrs
    end

    it "inserts new course" do

      t0 = Transcript.all.size

      row_service = ProcessStudent.new @inter_row
      row_service.upsert_course

      assert_equal Transcript.all.size, t0+1

    end

    it "updates existing course" do
      @course.save
      t0 = Transcript.all.size



      as_for_everyone={
        'SZVEDSD_GRADE' => 'A'
      }

      final_row = @inter_row.merge as_for_everyone
      row_service = ProcessStudent.new final_row
      row_service.upsert_course

      assert_equal Transcript.all.size, t0  #don't add a new course
      assert_equal (Transcript.find @course.id).grade_ltr, as_for_everyone['SZVEDSD_GRADE']

    end

  end



end