module PopulateHelper

    def pop_fois(stu)

      num_forms = Faker::Number.between 1, 2 #how many forms did they do?

        (num_forms).times do

          is_seeking_cert = Faker::Boolean.boolean 0.75

          if is_seeking_cert
            FactoryGirl.create :applying_foi, {:student_id => stu.id,
              :date_completing => Faker::Time.between(4.years.ago, 3.year.ago),
              :major_id => Major.all.sample.id}
          else
            FactoryGirl.create :not_applying_foi, {:student_id => stu.id,
              :date_completing => Faker::Time.between(4.years.ago, 3.year.ago),
              :eds_only => Faker::Boolean.boolean(0.5),
              :seek_cert => false}
          end

        end

    end

    def pop_adm_tep(stu, admit)
      #they're applying!

      date_apply = Faker::Time.between(3.years.ago, 2.years.ago)
      term = BannerTerm.current_term(options={
        date: date_apply,
        exact: false,
        plan_b: :back})

      num_programs = (Faker::Boolean.boolean 0.1) ? 2 : 1
      my_programs = Program.all.shuffle.slice(0, num_programs)

      app_attrs = my_programs.each.map { |prog|
        FactoryGirl.build :adm_tep, {
          :student_id => stu.id,
          :program => prog,
          :BannerTerm_BannerTerm => term.id,
          :TEPAdmit => admit,
          :TEPAdmitDate => (admit ? date_apply : nil),
          :GPA => nil,
          :GPA_last30 => nil,
          :EarnedCredits => nil
        }
      }

      if !(admit == false)
        #student qualifies for admission
        gpa = 3.0 #good enough GPA
        praxis_pass = true #pass the praxis
      else
        #student is denied admission
        gpa = 2.0 #not good enough GPA
        praxis_pass = false #fail praxis
      end

      pop_transcript stu, 12, gpa, term.StartDate - 200, term.EndDate

      # give student 150 2 terms ago and 227 1 term ago

      this_term = BannerTerm.current_term(:exact => false, :plan_b => :forward)
      prev_standard_terms = BannerTerm.where("BannerTerm < ?", this_term.id)
        .where({:standard_term => true})

      FactoryGirl.create :transcript, {
          :student => stu,
          :course_code => "EDS150",
          :banner_term => prev_standard_terms[-2]
      }

      FactoryGirl.create :transcript, {
          :student => stu,
          :course_code => "EDS227",
          :banner_term => prev_standard_terms[-1]
      }
      
      FactoryGirl.create :transcript, {
          :student => stu,
          :course_code => "EDS228",
          :banner_term => prev_standard_terms[-1]
      }
      
      pop_praxisI stu, date_apply - 30, praxis_pass

      app_attrs.each do |app|
        app.save
        byebug if !app.valid?
        if !admit == false
            adm_file = AdmFile.create!({
                :adm_tep_id => app.id,
                :student_file => (FactoryGirl.create :student_file, {:student => app.student})
            })
        end
      end

    end

    def pop_praxisI(stu, date_taken, passing)

      #for each required test, make attrs for a praxis_result
      p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})

      praxis_attrs = p1_tests.map { |test|
        FactoryGirl.attributes_for :praxis_result, {
          :student_id => stu.id,
          :praxis_test_id =>  test.id,
          :test_score => (passing ? test.CutScore : test.CutScore - 1),
          :test_date => date_taken,
          :reg_date => date_taken - 30
        }
       }

       praxis_attrs.map { |t| PraxisResult.create t }
    end

    def pop_transcript(stu, n, grade_pt, start_date, end_date)
      #gives student n courses all with the given grade
      #all courses are in terms between start and end date

      course_dates = n.times.map{ |i| Faker::Time.between(start_date, end_date) }
      course_terms = course_dates.map {|date| BannerTerm.current_term({
          :date => date,
          :exact => false,
          :plan_b => :back
        })
      }

      courses = course_terms.map {|term| FactoryGirl.build(:transcript, {
          :student_id => stu.id,
          :credits_attempted => 4.0,
          :credits_earned => 4.0,
          :gpa_include => true,
          :term_taken => term.id,
          :grade_pt => grade_pt,
          :grade_ltr => Transcript.g_to_l(grade_pt)
        })
      }

      courses.each { |i| i.save}

    end

    def pop_adm_st(stu)

      st_date_apply = Faker::Time.between(2.years.ago, 1.years.ago)
      st_apply_term = BannerTerm.current_term(options={
        date: st_date_apply,
        exact: false,
        plan_b: :back})

      #a student can apply, not apply (they drop the program) or have no activity yet.

      applying = Faker::Boolean.boolean 0.7  #are they going to apply for ST?

      if applying

        st_admit = Faker::Boolean.boolean 0.7
        num_apps = Faker::Number.between 1, 2

        if num_apps == 2
          #this is the first app, and always fails

          app = FactoryGirl.create :denied_adm_st, {
            student_id: stu.id,
            BannerTerm_BannerTerm: st_apply_term.id,
            OverallGPA: 2.75,
            CoreGPA: 3.0
          }

        end

        #here is the final application

        if st_admit
          st_app_attrs = FactoryGirl.create :accepted_adm_st, {
            student_id: stu.id,
            BannerTerm_BannerTerm: st_apply_term.id,
            OverallGPA: 2.75,
            CoreGPA: 3.0
          }
        else
          st_app_attrs = FactoryGirl.create :denied_adm_st, {
            student_id: stu.id,
            BannerTerm_BannerTerm: st_apply_term.id,
            OverallGPA: 2.75,
            CoreGPA: 3.0
          }
        end
      else
        # student hasn't applied. Have they dropped? or are they still eligible to apply

        will_drop = Faker::Boolean.boolean

        if will_drop #if this is false student is still eligible to apply
          progs_to_close = stu.open_programs

          drop_exit_code = ExitCode.find_by :ExitCode => "1826"
          progs_to_close.each do |prog|
            exit_attrs = FactoryGirl.create :prog_exit, {
              student_id: stu.id,
              Program_ProgCode: prog.program.id,
              ExitCode_ExitCode: drop_exit_code.id,
              ExitDate: st_date_apply,
              RecommendDate: nil
            }

          end

        end

      end

    end

  def exit_from_st(stu, completed)
    # exits a student from all programs following student teaching
    # completed: if the student successfully completed their programs
    # can be true, false or ni



    exit_date = Faker::Time.between(1.years.ago, 1.month.ago)

    if completed != false

      e_code = "1849"
      if completed
        rec_date = Faker::Time.between(exit_date, Date.today)
      else
        rec_date = nil
      end

    else

      e_code = "1809"

    end

    progs_to_close = stu.open_programs
    progs_to_close.each do |prog|

      exit_attrs = FactoryGirl.build :prog_exit, {
        :student_id => stu.id,
        :Program_ProgCode => prog.program.id,
        :ExitCode_ExitCode => (ExitCode.find_by :ExitCode =>e_code).id,
        :ExitDate => exit_date,
        :RecommendDate => rec_date
      }

      exit_attrs.save
    end

  end

  def pop_clinical_assignment(stu, teacher)

    # create an assignment for a course
    while true
      offset = rand(stu.transcripts.size)
      course = stu.transcripts.offset(offset).first
      break if course.clinical_assignments.blank?
    end

    term = course.banner_term
    start_date = term.StartDate
    end_date = term.EndDate

    assignment = FactoryGirl.build :clinical_assignment, {
      :student_id => stu.id,
      :clinical_teacher_id => teacher.id,
      :StartDate => start_date,
      :EndDate => end_date,
      :Term => term.id,
      :transcript => course
    }

    assignment.save
  end
end
