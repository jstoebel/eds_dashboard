require 'test_helper'

class ProcessStudentServiceTest < ActiveSupport::TestCase

  setup do
    ActionMailer::Base.deliveries.clear
    @row_template = {
      "szvedsd_id" => nil,
      "szvedsd_last_name" => nil,
      "szvedsd_first_name" => nil,
      "szvedsd_middle_name" => nil,
      "szvedsd_enroll_stat" => nil,
      "szvedsd_classification" => nil,
      "szvedsd_withdrawals" => nil,
      "szvedsd_term_graduated" => nil,
      "szvedsd_gender" => nil,
      "szvedsd_ssn" => nil,
      "szvedsd_dob" => nil,
      "szvedsd_race" => nil,
      "szvedsd_hispanic" => nil,
      "szvedsd_state" => nil,
      "szvedsd_county" => nil,
      "szvedsd_citizenship" => nil,
      "szvedsd_country_origin" => nil,
      "szvedsd_esl" => nil,
      "szvedsd_computer_toefl" => nil,
      "szvedsd_toefl" => nil,
      "szvedsd_toefl_essay" => nil,
      "szvedsd_toefl_listening" => nil,
      "szvedsd_toefl_reading" => nil,
      "szvedsd_toefl_speaking" => nil,
      "szvedsd_toefl_struct_writing" => nil,
      "szvedsd_toefl_total" => nil,
      "szvedsd_toefl_writing" => nil,
      "szvedsd_test_written_english" => nil,
      "szvedsd_ielts_listening" => nil,
      "szvedsd_ielts_reading" => nil,
      "szvedsd_ielts_writing" => nil,
      "szvedsd_ielts_speaking" => nil,
      "szvedsd_ielts_band_score" => nil,
      "szvedsd_transfer_student" => nil,
      "szvedsd_term_eds_explor_mjr" => nil,
      "szvedsd_term_declared_eds_mjr" => nil,
      "szvedsd_primary_major" => nil,
      "szvedsd_primary_major_conc" => nil,
      "szvedsd_secondary_major" => nil,
      "szvedsd_secondary_major_conc" => nil,
      "szvedsd_advisor" => nil,
      "szvedsd_high_school_gpa umber" => nil,
      "szvedsd_high_scholl_rank umber" => nil,
      "szvedsd_act_english" => nil,
      "szvedsd_act_math" => nil,
      "szvedsd_act_reading" => nil,
      "szvedsd_act_science_reasoning" => nil,
      "szvedsd_act_composite" => nil,
      "szvedsd_sat_verb_crit_reading" => nil,
      "szvedsd_sat_math" => nil,
      "szvedsd_sat_writing" => nil,
      "szvedsd_term_taken" => nil,
      "szvedsd_crn" => nil,
      "szvedsd_course" => nil,
      "szvedsd_grade" => nil,
      "szvedsd_registration_stat" => nil,
      "szvedsd_credits_attempted" => nil,
      "szvedsd_credits_earned" => nil,
      "szvedsd_minors" => nil,
      "szvedsd_gpa_ind" => nil,
      "szvedsd_email" => nil,
      "szvedsd_cpo" => nil,
      "szvedsd_filter_term" => nil,
      "savedsd_instructor" =>nil
      }

  end

  ###TESTS FOR UPSERT###
  describe "upsert_student" do

    before do

      @stu_count0 = Student.all.size
      @new_stu = FactoryGirl.attributes_for :student

      @new_attrs = {
        "szvedsd_id" => @new_stu[:Bnum],
        "szvedsd_last_name" => @new_stu[:LastName],
        "szvedsd_first_name" => @new_stu[:FirstName],
        "szvedsd_enroll_stat" => "Active Student",
        "szvedsd_middle_name" => @new_stu[:MiddleName],
        "szvedsd_classification" => @new_stu[:Classification],
        "szvedsd_withdrawals" => @new_stu[:withdraws],
        "szvedsd_term_graduated" => @new_stu[:term_graduated],
        "szvedsd_gender" => @new_stu[:gender],
        "szvedsd_ssn" => nil,
        "szvedsd_dob" => nil,
        "szvedsd_race" => @new_stu[:race],
        "szvedsd_hispanic" => @new_stu[:hispanic] ? "yes" : "no",
        "szvedsd_state" => nil,
        "szvedsd_county" => nil,
        "szvedsd_citizenship" => nil,
        "szvedsd_country_origin" => nil,
        "szvedsd_esl" => nil,
        "szvedsd_computer_toefl" => nil,
        "szvedsd_toefl" => nil,
        "szvedsd_toefl_essay" => nil,
        "szvedsd_toefl_listening" => nil,
        "szvedsd_toefl_reading" => nil,
        "szvedsd_toefl_speaking" => nil,
        "szvedsd_toefl_struct_writing" => nil,
        "szvedsd_toefl_total" => nil,
        "szvedsd_toefl_writing" => nil,
        "szvedsd_test_written_english" => nil,
        "szvedsd_ielts_listening" => nil,
        "szvedsd_ielts_reading" => nil,
        "szvedsd_ielts_writing" => nil,
        "szvedsd_ielts_speaking" => nil,
        "szvedsd_ielts_band_score" => nil,
        "szvedsd_transfer_student" => nil,
        "szvedsd_term_eds_explor_mjr" => nil,
        "szvedsd_term_declared_eds_mjr" => nil,
        "szvedsd_primary_major" => @new_stu[:CurrentMajor1],
        "szvedsd_primary_major_conc" => @new_stu[:concentration1],
        "szvedsd_secondary_major" => @new_stu[:CurrentMajor2],
        "szvedsd_secondary_major_conc" => @new_stu[:concentration2],
        "szvedsd_advisor" => nil,
        "szvedsd_high_school_gpa umber" => nil,
        "szvedsd_high_scholl_rank umber" => nil,
        "szvedsd_act_english" => nil,
        "szvedsd_act_math" => nil,
        "szvedsd_act_reading" => nil,
        "szvedsd_act_science_reasoning" => nil,
        "szvedsd_act_composite" => nil,
        "szvedsd_sat_verb_crit_reading" => nil,
        "szvedsd_sat_math" => nil,
        "szvedsd_sat_writing" => nil,
        "szvedsd_term_taken" => nil,
        "szvedsd_crn" => nil,
        "szvedsd_course" => nil,
        "szvedsd_grade" => nil,
        "szvedsd_registration_stat" => nil,
        "szvedsd_credits_attempted" => nil,
        "szvedsd_credits_earned" => nil,
        "szvedsd_minors" => @new_stu[:CurrentMinors],
        "szvedsd_gpa_ind" => nil,
        "szvedsd_email" => nil,
        "szvedsd_cpo" => @new_stu[:CPO],
        "szvedsd_filter_term" => nil,
        "savedsd_instructor" =>nil
      }

      @row = @row_template.merge @new_attrs
      @row_service = ProcessStudent.new @row
      @row_service.upsert_student
      @stu = Student.find_by :Bnum => @new_stu[:Bnum]
    end
    test "creates a new student" do
      assert Student.count == @stu_count0 + 1
    end

    describe "attrs match" do
      filter_attrs = [:Bnum, :LastName, :FirstName, :MiddleName,
        :EnrollmentStatus, :Classification, :withdraws, :term_graduated,
        :gender, :race, :hispanic, :CurrentMajor1, :concentration1,
        :CurrentMajor2, :concentration2, :CurrentMinors, :CPO
      ]
      filter_attrs.each do |attr|
        test "with attr #{attr}" do
          assert_equal @new_stu[attr], @stu.send(attr)
        end # test
      end # loop
    end # describe

    it "updates a student" do

      stu_count0 = Student.all.size
      new_stu = FactoryGirl.create :student

      new_attrs = {
        "szvedsd_id" => new_stu[:Bnum],
        "szvedsd_last_name" => new_stu[:LastName] + "!!!!",
        "szvedsd_first_name" => new_stu[:FirstName],
        "szvedsd_enroll_stat" => "Active Student",
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
          "szvedsd_id" => @stu[:Bnum],
          "szvedsd_last_name" => @stu[:LastName],
          "szvedsd_first_name" => @stu[:FirstName],
          "szvedsd_enroll_stat" => @stu[:EnrollmentStatus],
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
        "szvedsd_id" => @stu.Bnum,
        'szvedsd_advisor' => adv_str
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
        "szvedsd_id" => @stu.Bnum
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
        "szvedsd_id" => nil,
        'szvedsd_advisor' => adv_str
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      assert_raises(ActiveRecord::StatementInvalid){row_service.update_advisor_assignments}
    end

    it "doesn't create assignment - throws StatementInvalid" do

      adv_str = @advisors.map{ |a| "#{a.first_name} #{a.last_name} {Primary-#{a.AdvisorBnum}}" }.join("; ")

      new_attrs = {
        "szvedsd_id" => nil,
        'szvedsd_advisor' => adv_str
      }

      row = @row_template.merge new_attrs
      row_service = ProcessStudent.new row
      assert_raises(ActiveRecord::StatementInvalid){row_service.update_advisor_assignments}
    end

  end
  #
  # ###TESTS FOR UPSERT COURSE
  #
  describe "upsert_transcript" do
  #
    before do
      Transcript.delete_all
      @course = FactoryGirl.build :transcript, {:grade_ltr => 'C', :grade_pt => 2.0}
      term = BannerTerm.find @course[:term_taken]

      new_attrs={
        'szvedsd_id' => @course.student.Bnum,
        'szvedsd_term_taken' => "#{term.id} - #{term.PlainTerm}",
        'szvedsd_course' => "#{@course[:course_code].insert(3, " ")} - #{@course[:course_name]}",
        'szvedsd_grade' => @course[:grade_ltr],
        'szvedsd_crn' => @course[:crn],
        'szvedsd_credits_attempted' => @course[:credits_attempted],
        'szvedsd_credits_earned' => @course[:credits_earned],
        'szvedsd_registration_stat' => @course[:reg_status],
        'savedsd_instructor' => @course[:instructors],
        'szvedsd_gpa_ind' => @course[:gpa_include] ? "Include" : "Exclude"
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
        'szvedsd_grade' => 'A'
      }

      final_row = @inter_row.merge as_for_everyone
      row_service = ProcessStudent.new final_row
      row_service.upsert_course

      assert_equal Transcript.all.size, t0  #don't add a new course
      assert_equal (Transcript.find @course.id).grade_ltr, "A"
      assert_equal (Transcript.find @course.id).grade_pt, 4.0
    end

    test "grade_ltr nil" do
      @course.save!

      nil_grade_ltr ={
        'szvedsd_grade' => nil
      }

      final_row = @inter_row.merge nil_grade_ltr
      row_service = ProcessStudent.new final_row
      row_service.upsert_course

      assert_equal 1, Transcript.count
    end

    test "3 character course code" do
      @inter_row.merge!({
          'szvedsd_course' => "EDS 150 - A 3 char course",
        })
        row_service = ProcessStudent.new @inter_row
        row_service.upsert_course
        assert_equal "EDS150", row_service.course.course_code

    end

    test "4 character course code" do
      @inter_row.merge!({
          'szvedsd_course' => "GSTR 110 - A 4 char course",
        })
        row_service = ProcessStudent.new @inter_row
        row_service.upsert_course
        assert_equal "GSTR110", row_service.course.course_code
    end

    test "course section" do
      @inter_row.merge!({
          'szvedsd_course' => "GSTR 110A - A 4 char course",
        })
        row_service = ProcessStudent.new @inter_row
        row_service.upsert_course
        assert_equal "A", row_service.course.course_section
    end

    test "irregular course code" do
      @inter_row.merge!({
          'szvedsd_course' => "GSTRRR 110 - A strange course code",
        })
        row_service = ProcessStudent.new @inter_row
        row_service.upsert_course
        assert_equal "GSTRRR110", row_service.course.course_code
    end

    test "irregular course code no dash" do
      # very strange format for course, there isn't even a dash seperating the course code and name
      @inter_row.merge!({
          'szvedsd_course' => "strangecourse",
        })
        row_service = ProcessStudent.new @inter_row
        row_service.upsert_course
        assert_equal "strangecourse", row_service.course.course_code

    end

    describe "gpa_include" do

      ["Include", "Include in GPA Only", "something strange", nil].each do |val|

        test "true value: #{val.to_s}" do
          @inter_row["szvedsd_gpa_ind"] = val
          row_service = ProcessStudent.new @inter_row
          row_service.upsert_course
          assert_equal true, row_service.course.gpa_include
        end

      end # loop

      test "false value: Exclude" do
        @inter_row["szvedsd_gpa_ind"] = "exclude"
        row_service = ProcessStudent.new @inter_row
        row_service.upsert_course
        assert_equal false, row_service.course.gpa_include
      end

    end # describe

  end # upsert transcript

end
