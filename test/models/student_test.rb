# == Schema Information
#
# Table name: students
#
#  id                      :integer          not null, primary key
#  Bnum                    :string(9)        not null
#  FirstName               :string(45)       not null
#  PreferredFirst          :string(45)
#  MiddleName              :string(45)
#  LastName                :string(45)       not null
#  PrevLast                :string(45)
#  EnrollmentStatus        :string(45)
#  Classification          :string(45)
#  CurrentMajor1           :string(45)
#  concentration1          :string(255)
#  CurrentMajor2           :string(45)
#  concentration2          :string(255)
#  CellPhone               :string(45)
#  CurrentMinors           :string(255)
#  Email                   :string(100)
#  CPO                     :string(45)
#  withdraws               :text(65535)
#  term_graduated          :integer
#  gender                  :string(255)
#  race                    :string(255)
#  hispanic                :boolean
#  term_expl_major         :integer
#  term_major              :integer
#  presumed_status         :string(255)
#  presumed_status_comment :text(65535)
#

require 'test_helper'
require 'minitest/autorun'
require 'factory_girl'
class StudentTest < ActiveSupport::TestCase

    let(:new_stu) {FactoryGirl.create :student}
    let(:now_term) {FactoryGirl.create :banner_term, :StartDate => 10.days.ago,
        :EndDate => 10.days.from_now
    }

    ######################################~~~TESTS FOR SCOPES~~~##########################################

    test "by_last scope" do
        stus = FactoryGirl.create_list :student, 5
        expected = Student.all.order(LastName: :asc)
        assert_equal stus.to_a.sort, expected.to_a.sort
    end

    test "active_student" do
        stus = FactoryGirl.create_list :student, 5 # all Active Student
        actual = Student.active_student
        assert_equal(stus.to_a.sort, actual.to_a.sort)
    end

    test "current scope" do
        #tests the scope called current
        stus = [
            (FactoryGirl.create :student),
            (FactoryGirl.create :admitted_student)
        ]
        expected = Student.select {|s| ["Candidate", "Prospective"].include?(s.prog_status) }
        assert_equal stus.to_a.sort, expected.to_a.sort

    end

    test "candidates scope" do
        stus = FactoryGirl.create_list :admitted_student, 2
        expected = Student.select {|s| ["Candidate"].include?(s.prog_status) }
        assert_equal stus.to_a.sort, expected.to_a.sort
    end

    describe "with_name scope" do
        fields = [:FirstName, :PreferredFirst, :LastName]
        fields.each do |f|
            test f do
                stu = FactoryGirl.create :student
                query = Student.with_name(stu.send(f))
                students = Student.joins(:last_names).where(query)
                assert_equal [stu], students.to_a
            end
        end

        test "with last_names table" do
            stu = FactoryGirl.create :student
            stu.LastName = "new-last"
            stu.save
            stu_last = stu.last_names.first.last_name
            query = Student.with_name(stu_last)
            students = Student.joins(:last_names).where(query)
            assert_equal [stu], students.to_a
        end
    end

    test "with_name - multiword string" do
        stu = FactoryGirl.create :student
        search_str = "#{stu.FirstName} spam"
        query = Student.with_name(search_str)
        students = Student.joins(:last_names).where(query)
        assert_equal [stu], students.to_a
    end

    test "is advisee of passes" do
        assignment = FactoryGirl.create :advisor_assignment
        s = assignment.student
        adv = assignment.tep_advisor
        assert s.is_advisee_of(adv)
    end

    test "is advisee of fails" do
        assignment = FactoryGirl.create :advisor_assignment
        s = assignment.student
        adv = assignment.tep_advisor
        assert (s.is_advisee_of("bad bnum") == false)
    end

    test "is student of passes" do
        stu = new_stu
        term = now_term
        prof_bnum = "B00123456"
        course = FactoryGirl.create :transcript, {:student => stu,
            :banner_term => term,
            :instructors => "last, first {#{prof_bnum}}"
        }
        assert stu.is_student_of?("B00123456"), "inst B# is " + prof_bnum
    end

    test "is student of fails bad term" do
        # student has this prof but not in the current term

        stu = new_stu
        term = now_term
        prof_bnum = "B00123456"
        course = FactoryGirl.create :transcript, {:student => stu,
            :banner_term => term.prev_term,
            :instructors => "last, first {#{prof_bnum}}"
        }
        assert_not stu.is_student_of?("B00123456"), "inst B# is " + prof_bnum
    end

    test "is student of fails not student" do

        stu = new_stu
        term = now_term
        prof_bnum = "B00111111"
        course = FactoryGirl.create :transcript, {:student => stu,
            :banner_term => term,
            :instructors => "last, first {#{prof_bnum}}"
        }
        assert stu.is_student_of?(prof_bnum), "inst B# is " + prof_bnum
    end

    test "is_student_of fails - no courses have instructors" do
        # this happens with students who have only transfered courses.
        # explicetly test that method doesn't blow up

        course = FactoryGirl.create :transcript, {:instructors => nil,
                :term_taken => BannerTerm.current_term({:exact => false, :plan_b => :forward}).id
        }
        stu = course.student
        adv = FactoryGirl.create :tep_advisor
        AdvisorAssignment.create({:student_id => stu.id, :tep_advisor_id => adv.id})
        prof_bnum = adv.AdvisorBnum
        assert_not stu.is_student_of?(prof_bnum)

    end

    describe "student instructor methods" do

        before do
            @adv = FactoryGirl.create :tep_advisor
            @stu = FactoryGirl.create :student, {:term_graduated => nil,
                :term_expl_major => nil,
                :term_major => nil
            }
            @now_term = FactoryGirl.create :banner_term, {:StartDate => 10.days.ago,
                :EndDate => 10.days.from_now,
                :PlainTerm => "created on 176"
            }
            @course_template = FactoryGirl.attributes_for :transcript, {:student_id => @stu.id,
                :grade_ltr => "A"
            }
        end

        describe "is_present_student_of" do

            test "returns true" do

                @course_template.merge!({:term_taken => @now_term.id,
                    :instructors => "#{@adv.first_name} #{@adv.last_name} {#{@adv.AdvisorBnum}}"})
                Transcript.create! @course_template
                assert @stu.is_present_student_of? @adv.AdvisorBnum
            end

            test "returns false - no courses in this term" do
                @course_template.merge!({:term_taken => @now_term.next_term.id,
                    :instructors => "#{@adv.first_name} #{@adv.last_name} {#{@adv.AdvisorBnum}}"})
                Transcript.create! @course_template
                assert_not @stu.is_present_student_of? @adv.AdvisorBnum

            end

        end

        describe "is_recent_student_of" do
            # does student have a course in a term that just happened?

            test "returns true" do
                @course_template.merge!({:term_taken => @now_term.prev_term.id,
                    :instructors => "#{@adv.first_name} #{@adv.last_name} {#{@adv.AdvisorBnum}}"})
                course = Transcript.create! @course_template
                travel_to (course.banner_term.EndDate + 10.day) do
                    assert @stu.is_recent_student_of? @adv.AdvisorBnum
                end
            end

            test "returns false - no courses" do

                @course_template.merge!({:term_taken => @now_term.prev_term.id})
                Transcript.create! @course_template
                travel_to (@now_term.StartDate - 10) do
                    assert_not @stu.is_recent_student_of? @adv.AdvisorBnum
                end

            end

            test "returns false - not between terms" do

                @course_template.merge!({:term_taken => @now_term.prev_term.id,
                    :instructors => "#{@adv.first_name} #{@adv.last_name} {#{@adv.AdvisorBnum}}"})
                Transcript.create! @course_template

                assert_not @stu.is_recent_student_of? @adv.AdvisorBnum

            end

        end

        describe "will_be_student_of" do
            # does student have courses in the term that is about to happen?

            test "returns true" do
                @course_template.merge!({:term_taken => @now_term.next_term.id,
                    :instructors => "#{@adv.first_name} #{@adv.last_name} {#{@adv.AdvisorBnum}}"})
                Transcript.create! @course_template

                travel_to (@now_term.EndDate + 10.day) do
                    assert @stu.will_be_student_of? @adv.AdvisorBnum
                end

            end

            test "returns false - no courses" do
                @course_template.merge!({:term_taken => @now_term.next_term.id})
                Transcript.create! @course_template
                travel_to (@now_term.EndDate + 10) do
                    assert_not @stu.is_recent_student_of? @adv.AdvisorBnum
                end
            end

            test "returns false - not between terms" do
                @course_template.merge!({:term_taken => @now_term.next_term.id})
                Transcript.create! @course_template
                assert_not @stu.is_recent_student_of? @adv.AdvisorBnum
            end

        end

        describe "has_incomplete_with" do

            test "returns true" do
                @course_template.merge!({:grade_ltr => "I",
                    :instructors => "#{@adv.first_name} #{@adv.last_name} {#{@adv.AdvisorBnum}}"})
                Transcript.create! @course_template

                assert @stu.has_incomplete_with? @adv.AdvisorBnum
            end

            test "returns false - incomplete with other" do
                @course_template.merge!({:grade_ltr => "I"})
                Transcript.create! @course_template
                assert_not @stu.has_incomplete_with? @adv.AdvisorBnum

            end

            test "returns false - no incompletes" do
                Transcript.create! @course_template
                assert_not @stu.has_incomplete_with? @adv.AdvisorBnum
            end

        end
    end

    ######################################################################################################



    describe "praxisI_pass" do
        before do
            @stu = FactoryGirl.create :student
            @test = FactoryGirl.create :praxis_test, {:TestFamily => "1",
                :CurrentTest => true
            }
            @result = FactoryGirl.build :praxis_result, {:student => @stu,
                :praxis_test => @test
            }
        end

        test "passing" do
            @result.test_score = @test.CutScore
            @result.save!
            assert @stu.praxisI_pass
        end

        test "not passing" do
            @result.test_score = @test.CutScore - 1
            @result.save!
            assert_not @stu.praxisI_pass
        end

    end
    #
    # ################################~~~TESTS for Prog_Status~~~#######################################
    #
    test "latest_foi" do
        foi1 = FactoryGirl.create :applying_foi
        stu = foi1.student
        # create an earlier foi
        FactoryGirl.create :applying_foi, :date_completing => (foi1.date_completing - 1.day)
        assert_equal foi1, stu.latest_foi
    end

    test "was_dismissed" do
        stu = FactoryGirl.create :student
        stu.EnrollmentStatus = "Dismissed - Academic"
        stu.save
        assert stu.was_dismissed?
    end

    test "was_dismissed false" do
        stu = FactoryGirl.create :student
        stu.EnrollmentStatus = "Active Student"
        stu.save
        assert_not stu.was_dismissed?
    end

    test "returns prospective no foi" do
        s = FactoryGirl.create :student
        s.EnrollmentStatus = "Active Student"
        s.save
        assert_equal "Prospective", s.prog_status
    end

    ["Graduation", "WD-Transferring", nil, ""].each do |enroll_status|
        test "returns not applying, enroll status=#{enroll_status.to_s}" do
            s = FactoryGirl.create :student
            s.EnrollmentStatus = enroll_status
            s.save
            assert_equal "Not applying", s.prog_status
        end
    end

    test "returns candidate despite negative foi" do
        stu = FactoryGirl.create :admitted_student
        neg_foi = FactoryGirl.create :not_applying_foi, {:student_id => stu.id}

        assert_equal "Candidate", stu.prog_status
    end

    test "returns prospective positive foi" do
        foi = FactoryGirl.create :applying_foi
        stu = foi.student
        assert_equal "Prospective", stu.prog_status
    end

    test "returns not applying foi" do
        foi = FactoryGirl.create :not_applying_foi
        stu = foi.student
        assert_equal "Not applying", stu.prog_status
    end

    test "returns not applying dismissed" do
        stu = FactoryGirl.create :student
        stu.EnrollmentStatus = "Dismissed - Academic"
        assert_equal "Not applying", stu.prog_status
    end

    test "returns candidate" do
        stu = FactoryGirl.create :admitted_student
        assert_equal "Candidate", stu.prog_status
    end

    test "returns dropped" do

        # create an admitted student then have them drop
        stu = FactoryGirl.create :admitted_student
        prog_exit = FactoryGirl.create :prog_exit, {:student => stu,
            :exit_code => (FactoryGirl.create :exit_code, {:ExitCode => "1826"}),
            :program => stu.adm_tep.first.program,
            :RecommendDate => nil
        }
        stu = prog_exit.student
        assert_equal "Dropped", stu.prog_status

    end

    test "returns completer" do
        prog_exit = FactoryGirl.create :successful_prog_exit
        stu = prog_exit.student
        assert_equal "Completer", stu.prog_status
    end

    test "returns completer with one drop" do
        stu = FactoryGirl.create :admitted_student
        first_adm = stu.adm_tep.first

        # enter  second program
        second_adm = FactoryGirl.create :adm_tep, {:student_id => stu.id,
            :program => (FactoryGirl.create :program),
            :banner_term => first_adm.banner_term
        }

        # drop one of the programs
        drop_code = FactoryGirl.create :exit_code, {:ExitCode => "1826"}
        FactoryGirl.create :prog_exit, {:student => stu,
            :program => first_adm.program,
            :ExitCode_ExitCode => drop_code.id,
            :RecommendDate => nil
        }

        # complete the other program
        stu.update_attributes! :EnrollmentStatus => "Graduation"

        completer_code = FactoryGirl.create :exit_code, {:ExitCode => "1849"}
        FactoryGirl.create :prog_exit, {:student => stu,
            :program => second_adm.program,
            :ExitCode_ExitCode => completer_code.id
        }

        assert_equal "Completer", stu.prog_status
    end

    ######################################################################################################

    describe "name_readable" do

        test "one name" do
            stu = FactoryGirl.create :student, {:PreferredFirst => nil, :PrevLast => nil}
            assert_equal "#{stu.FirstName} #{stu.LastName}", stu.name_readable
        end

        test "with pref_first" do
            stu = FactoryGirl.create :student, {:PrevLast => nil}
            assert_equal "#{stu.PreferredFirst} (#{stu.FirstName}) #{stu.LastName}", stu.name_readable
        end

        test "file_as" do
            stu = FactoryGirl.create :student, {:PreferredFirst => nil, :PrevLast => nil}
            assert_equal "#{stu.LastName}, #{stu.FirstName}", stu.name_readable(file_as=true)
        end

    end

    test "open_programs" do
        stu = FactoryGirl.create :admitted_student
        apps = stu.adm_tep.where(:TEPAdmit => true)
        expected = apps.select { |a| ProgExit.find_by({:student_id => a.student_id, :Program_ProgCode => a.Program_ProgCode}) == nil }

        assert_equal expected.to_a, stu.open_programs.to_a
    end

    describe "gpa" do

        before do
            first_term = BannerTerm.all.first
            @first_course = FactoryGirl.create :transcript, {
                term_taken: first_term.id,
                grade_pt: 4.0,
                grade_ltr: "A"
            }
            @stu = @first_course.student
        end

        test "gpa with no options" do
            assert_equal 4.0, @stu.gpa
        end

        test "gpa with term limit" do

            first_term = @first_course.banner_term
            next_term = first_term.next_term

            FactoryGirl.create :transcript, {
                    student_id: @stu.id,
                    term_taken: next_term.id,
                    grade_pt: 3.0,
                    grade_ltr: "B"
                }

            assert_equal 4.0, @stu.gpa({term: @first_course.term_taken})
        end

        test "gpa with credit limit" do

            second_course = FactoryGirl.create :transcript, {
                term_taken: @first_course.banner_term.id,
                student_id: @stu.id,
                grade_pt: 3.0,
                grade_ltr: "B"
            }

            assert_equal 4.0, @stu.gpa({last: second_course.credits_earned * 4})
        end

        test "gpa with a course having nil credits attempted" do
            second_course = FactoryGirl.create :transcript, {
                term_taken: @first_course.banner_term.id,
                student_id: @stu.id,
                grade_pt: 3.0,
                grade_ltr: "B",
                credits_attempted: nil
            }

            assert_equal 4.0, @stu.gpa

        end

        test "gpa with course having nil quality points" do
            second_course = FactoryGirl.create :transcript, {
                term_taken: @first_course.banner_term.id,
                student_id: @stu.id,
                grade_pt: 3.0,
                grade_ltr: "B"
            }

            second_course.quality_points = nil
            second_course.save!

            assert_equal nil, second_course.quality_points
            assert_equal 4.0, @stu.gpa

        end

        test "gpa with course having nil grade_ltr" do
            second_course = FactoryGirl.create :transcript, {
                term_taken: @first_course.banner_term.id,
                student_id: @stu.id,
                grade_pt: 3.0,
            }
            assert_equal 4.0, @stu.gpa
        end


        test "convocation affects GPA" do

            b_grade = FactoryGirl.create :transcript, {
                :term_taken => BannerTerm.first.id,
                :grade_ltr => "B",
                :grade_pt => 3.0,
                :credits_earned => 1.0,
                :credits_attempted => 1.0
            }

            convo_credit = FactoryGirl.create :transcript, {
                term_taken: @first_course.banner_term.id,
                student_id: b_grade.student.id,
                grade_ltr: "CA",
                grade_pt: 0
            }

            assert_equal 3.2, b_grade.student.gpa

        end

        test "student has no courses" do
            stu = FactoryGirl.create :student
            assert_equal 0, stu.gpa
        end

        test "ignores course with gpa_include==false" do
            excluded_course = FactoryGirl.create :transcript, :gpa_include => false

            assert_equal @first_course.grade_pt, @stu.gpa
        end

    end # describe gpa

    describe "credits" do

        describe "with courses" do

            before do
                @stu = FactoryGirl.create :student
                @this_term = BannerTerm.current_term({:exact => false, :plan_b => :back})
                credits = [1.0, nil]
                # make 4 courses, two for each term, one with a credit earnedm the other nil
                [@this_term, @this_term.next_term].each do |t|
                    credits.each do |c|
                        FactoryGirl.create :transcript, {:student_id => @stu.id,
                            :term_taken => t.id,
                            :credits_earned => c
                        }
                    end
                end
            end

            test "no term limit" do
                courses = @stu.transcripts.where("credits_earned is not null")
                expected_credits = courses.map{|c| c.credits_earned}.inject(:+)*4.0
                assert_equal expected_credits, @stu.credits
            end

            test "with term limit" do
                courses = @stu.transcripts
                    .where("credits_earned is not null")
                    .where("term_taken <= ?", @this_term.id)

                expected_credits = courses
                    .map{|c| c.credits_earned}
                    .inject(:+) * 4.0
                assert_equal expected_credits, @stu.credits(@this_term.id)
            end

        end

        test "with no courses" do
            stu = FactoryGirl.create :student
            assert_equal 0, stu.credits
        end

    end


    it "updates last_name table" do
        stu = FactoryGirl.create :student
        stu.LastName = "new-name"
        stu.save
        expect LastName.where(student_id: stu.id).size.must_equal 2

    end # credits

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

    # TODO: needs fixing.


    # let(:students){
    # 	[
    #         {
    #             "Bnum"=> "B00999992",
    #             "FirstName"=> "Joe",
    #             "MiddleName"=> "J",
    #             "LastName"=> "Joseph",
    #             "EnrollmentStatus"=>"Active Student",
    #             "Classification"=> "Senior",
    #             "CurrentMajor1"=> "Education Studies",
    #             "concentration1"=> "Elementary",
    #             "CurrentMajor2"=> "English",
    #             "concentration2"=> "Literature",
    #             "CurrentMinors"=> "spamspamspam",
    #             "Email"=>"josephj@berea.edu",
    #             "CPO"=>"123",
    #             "withdraws"=>"eggs; bakedbeans",
    #             "term_graduated"=> 201611,
    #             "gender"=> "Male",
    #             "race"=> "none of your bussiness",
    #             "hispanic"=> true,
    #             "term_expl_major"=> 201411,
    #             "term_major"=> 201511
    #         },
    #
    #         {
    #             "Bnum"=> "B00999991",
    #             "FirstName"=> "Jacob",
    #             "MiddleName"=> "B",
    #             "LastName"=> "Stoebel",
    #             "EnrollmentStatus"=>"Active Student",
    #             "Classification"=> "Senior",
    #             "CurrentMajor1"=> "Education Studies",
    #             "concentration1"=> "Elementary",
    #             "CurrentMajor2"=> "English",
    #             "concentration2"=> "Literature",
    #             "CurrentMinors"=> "spamspamspam",
    #             "Email"=>"stoebelj@berea.edu",
    #             "CPO"=>"123",
    #             "withdraws"=>"eggs; bakedbeans",
    #             "term_graduated"=> 201611,
    #             "gender"=> "Male",
    #             "race"=> "none of your bussiness",
    #             "hispanic"=> true,
    #             "term_expl_major"=> 201411,
    #             "term_major"=> 201511
    #         }
    #
    # 	]}
    #
    # it "batch uploads students" do
    # 	s0 = Student.all.size
    # 	Student.batch_create(students)
    # 	s1 = Student.all.size
    # 	expect (s1-s0).must_equal(2)
    # end
    #
    # it "does not batch upload students" do
    # 	#try to submit the same data twice. We should end up with two new records (not four)
    #
    # 	s0 = Student.all.size
    # 	2.times {|i| Student.batch_create(students)}
    # 	s1 = Student.all.size
    # 	expect (s1-s0).must_equal(2)
    # end
    #
    # it "batch updates students" do
    # 	#create 2 students
    # 	stus = FactoryGirl.create_list :student, 2
    # 	update_attrs = stus.map{|s| {:id => s.id, :CurrentMajor1 => "new major"}}
    # 	Student.batch_update(update_attrs)
    #
    # 	#both students should have changed their major
    # 	assert update_attrs.map{ |attr| Student.find(attr[:id]).CurrentMajor1  == "new major"}.all?
    #
    # end
    #
    # it "does not batch update students failed validation" do
    # 	#make a validation fail
    #
    # 	#create 2 students
    # 	stus = FactoryGirl.create_list :student, 2
    # 	update_attrs = stus.map{|s| {:id => s.id, :EnrollmentStatus => nil}}
    #
    #
    # 	result = Student.batch_update(update_attrs)
    # 	assert_equal false, result[:success]
    # 	assert_equal "Validation failed: Enrollmentstatus can't be blank", result[:msg]
    #
    # end
    #
    # it "does not batch update students can't find record" do
    # 	stus = FactoryGirl.create_list :student, 1
    # 	update_attrs = stus.map{|s| {:id => "blah", :CurrentMajor1 => "new major"}}
    # 	result = Student.batch_update(update_attrs)
    # 	assert_equal false, result[:success]
    # 	assert_equal "Couldn't find Student with 'id'=#{update_attrs[0][:id]}", result[:msg]
    # end
    #
  # test "Object not valid, validations failed" do
    #   stu=Student.new
    #   assert_not stu.valid?
    #   assert_equal [:Bnum, :FirstName, :LastName, :EnrollmentStatus], stu.errors.keys
    #   assert_equal [:Bnum, :FirstName, :LastName, :EnrollmentStatus].map{|i| [i, ["can't be blank"]]}.to_h,
    #     stu.errors.messages
    # end
    #
    # describe "presumed_status validation" do
    # 	before do
    # 		@stu = FactoryGirl.create :student
    # 	end
    #
    # 	["Prospective", "Not Applying", "Candidate", "Dropped", "Completer", nil].each do |status|
    #
    # 		test "allows value: #{status}" do
    # 			@stu.presumed_status = status
    # 			assert @stu.valid?
    #
    # 		end # test
    # 	end # loop
    #
    # 	test "disallows bogus status" do
    # 		@stu.presumed_status = "crazy pants"
    # 		assert_not @stu.valid?
    # 	end
    # end # describe
    #
    test "tep_instructors" do
        @stu = FactoryGirl.create :student
        advs = FactoryGirl.create_list :tep_advisor, 3

        # make student a current student of each adv
        term = BannerTerm.current_term({:exact => false, :plan_b => :back})
        advs.each{|adv| FactoryGirl.create :transcript,
            {:instructors => "InstFirst InstLast {#{adv.AdvisorBnum}}",
                :student_id => @stu.id,
                :term_taken => term.id
            }
        }

        assert_equal 3, @stu.tep_instructors.size
        assert_equal advs, @stu.tep_instructors
    end

    # TODO tests for graduated and transfered
end
