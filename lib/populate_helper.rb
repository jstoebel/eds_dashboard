module PopulateHelper

    def pop_fois(stu)

      num_forms = Faker::Number.between 1, 2 #how many forms did they do?

        (num_forms).times do
          seek_cert = Faker::Boolean.boolean 0.75
          eds_only = Faker::Boolean.boolean if !seek_cert

          FactoryGirl.create :foi, {
            student_id: stu.id,
            date_completing: Faker::Time.between(4.years.ago, 3.year.ago),
            major_id: Major.all.sample.id,
            seek_cert: seek_cert,
            eds_only: eds_only
            }
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
          :Program_ProgCode => prog.id,
          :BannerTerm_BannerTerm => term.id,
          :TEPAdmit => admit,
          :TEPAdmitDate => (admit ? date_apply : nil),
          :GPA => nil,
          :GPA_last30 => nil,
          :EarnedCredits => nil,
          :student_file_id => (admit != nil ? FactoryGirl.create(:student_file, {:student_id => stu.id}).id : nil)
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
      pop_praxisI stu, date_apply - 30, praxis_pass

      app_attrs.each do |i|
        i.save
      end

    end

    def pop_praxisI(stu, date_taken, passing)

      #for each required test, make attrs for a praxis_result
      p1_tests = PraxisTest.where({:TestFamily => 1, :CurrentTest => true})

      praxis_attrs = p1_tests.map { |test|
        FactoryGirl.attributes_for :praxis_result, {
          :student_id => stu.id,
          :praxis_test_id =>  test.id,
          :test_score => (passing ? 101 : 99),
          :cut_score => 100,
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

          app = FactoryGirl.attributes_for :adm_st, {
            student_id: stu.id,
            BannerTerm_BannerTerm: st_apply_term.id,
            OverallGPA: 2.75,
            CoreGPA: 3.0,
            STAdmitted: false,
            STAdmitDate: nil,
            student_file_id: (st_admit != nil ? FactoryGirl.create(:student_file, {:student_id => stu.id}).id : nil)
          }

          AdmSt.create app

        end

        #here is the final application

        st_app_attrs = FactoryGirl.attributes_for :adm_st, {
          student_id: stu.id,
          BannerTerm_BannerTerm: st_apply_term.id,
          OverallGPA: 2.75,
          CoreGPA: 3.0,
          STAdmitted: st_admit,
          STAdmitDate: (st_admit ? st_date_apply : nil),
          student_file_id: (st_admit != nil ? FactoryGirl.create(:student_file, {:student_id => stu.id}).id : nil)
        }

        st_admit_attrs = {STAdmitted: st_admit}

        final_app = AdmSt.create st_app_attrs.merge(st_admit_attrs)
        if final_app.errors.present?
          puts final_app.errors.full_messages
          puts final_app.inspect
          exit
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


    start_date = Faker::Time.between(4.years.ago, Date.today)
    term = BannerTerm.current_term({
      :exact => false,
      :plan_b => :forward,
      :date => start_date
    })

    end_date = term.EndDate

    assignment = FactoryGirl.build :clinical_assignment, {
      :student_id => stu.id,
      :clinical_teacher_id => teacher.id,
      :StartDate => start_date,
      :EndDate => end_date,
      :Term => term.id
    }

    assignment.save

  end

end
