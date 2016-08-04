require 'test_helper'

class ProcessStudentServiceTest < ActiveSupport::TestCase

  setup do

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

  test "creates a new student" do

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

  test "updates a student" do

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

  test "does not upsert student, throws exception" do

    row_service = ProcessStudent.new @row_template  # passing in empy row
    assert_raises(ActiveRecord::RecordInvalid) {row_service.upsert_student}

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
      @advisors.each{|a| assert @stu.is_advisee_of a}
    end

    it "removes all advisors" do
      new_attrs = {
        "SZVEDSD_ID" => @stu.Bnum
      } # no advisors!

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      row_service.update_advisor_assignments

      assert_equal @stu.advisor_assignments.size, 0
      @advisors.each{|a| assert_not @stu.is_advisee_of a}

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

  it "inserts new course" do
    course = FactoryGirl.attributes_for :transcript
    term = BannerTerm.find course[:term_taken]

    new_attrs={
      'SZVEDSD_TERM_TAKEN' => "#{term.id} - #{term.PlainTerm}",
      'SZVEDSD_COURSE' => course[:course_code].insert(3, " "),
      'SZVEDSD_GRADE' => course[:grade_pt],
      'SZVEDSD_CRN' => course[:crn],
      'SZVEDSD_CREDITS_ATTEMPTED' => course[:credits_attempted],
      'SZVEDSD_CREDITS_EARNED' => course[:credits_earned],
      'SZVEDSD_REGISTRATION_STAT' => course[:reg_status],
      'SAVEDSD_INSTRUCTOR' => course[:instructors]
      'SZVEDSD_GPA_IND' => course[:gpa_include]
    }

  end

  it "updates existing course" do

  end



end
