module PopulateHelper

    def pop_fois(stu)

      p __method__

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

      p __method__

      

      date_apply = Faker::Time.between(3.years.ago, 2.years.ago)
      term = BannerTerm.current_term(options={
        date: date_apply,
        exact: false,
        plan_b: :back})

      num_programs = (Faker::Boolean.boolean 0.1) ? 2 : 1
      my_programs = Program.all.shuffle.slice(0, num_programs)

      app_attrs = my_programs.each.map { |prog| 
        FactoryGirl.attributes_for :adm_tep, {
          :student_id => stu.id,
          :Program_ProgCode => prog.id,
          :BannerTerm_BannerTerm => term.id,
          :TEPAdmit => admit,
          :TEPAdmitDate => date_apply,
          :GPA => nil,
          :GPA_last30 => nil, 
          :EarnedCredits => nil,
          :student_file_id => FactoryGirl.create(:student_file, {:student_id => stu.id}).id
        }
      }
    
      if !admit == false
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
      app_attrs.map {|attr| FactoryGirl.create :adm_tep, attr}
    end

    def pop_praxisI(stu, date_taken, passing)
      p __method__

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
    end

    def pop_transcript(stu, n, grade_pt, start_date, end_date)
      p __method__
      #gives student n courses all with the given grade
      #all courses are in terms between start and end date

      course_dates = n.times.map{ |i| Faker::Time.between(start_date, end_date) }
      course_terms = course_dates.map {|date| BannerTerm.current_term({
          :date => date,
          :exact => false,
          :plan_b => :back
        })
      }

      courses = course_terms.map {|term| FactoryGirl.create(:transcript, {
          :student_id => stu.id,
          :credits_attempted => 4.0,
          :credits_earned => 4.0,
          :gpa_include => true,
          :term_taken => term.id,
          :grade_pt => grade_pt,
          :grade_ltr => Transcript.g_to_l(grade_pt)
        })
      }

    end

    def pop_adm_st(stu)
      p __method__
      

      st_date_apply = Faker::Time.between(2.years.ago, 1.years.ago)
      st_apply_term = BannerTerm.current_term(options={
        date: st_date_apply,
        exact: false,
        plan_b: :back})

      applying = Faker::Boolean.boolean 0.7  #are they going to apply for ST?

      if applying

        st_admit = Faker::Boolean.boolean 0.7
        num_apps = Faker::Number.between 1, 2

        if num_apps == 2
          #this is the first app, and always fails
          
          FactoryGirl.create :adm_st, {
            student_id: stu.id,
            BannerTerm_BannerTerm: st_apply_term.id,
            OverallGPA: 2.75,
            CoreGPA: 3.0,
            STAdmitted: false,
            STAdmitDate: nil,
          }

        end

        #here is the final application

        st_app_attrs = FactoryGirl.attributes_for :adm_st, {
          student_id: stu.id,
          BannerTerm_BannerTerm: st_apply_term.id,
          OverallGPA: 2.75,
          CoreGPA: 3.0,
          STAdmitted: st_admit,
          STAdmitDate: nil,          
        }

        st_admit_attrs = {STAdmitted: st_admit}

        AdmSt.create st_app_attrs.merge(st_admit_attrs) 

      else
        #student drops the program. They need to be exited.

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

  def exit_from_st(stu, completed)
      p __method__
    # exits a student from all programs following student teaching
    # completed: if the student successfully completed their programs
    # can be true, false or nil

    

    exit_date = Faker::Time.between(1.years.ago, 1.month.ago)

    if completed != false

      e_code = "1849"
      if completed
        rec_date = Faker::Time.between(exit_date, Date.today)
      else
        rec_date = nil
      end

      stu.EnrollmentStatus = "Graduation"
      stu.save

    else

      e_code = "1809"

    end

    progs_to_close = stu.open_programs
    progs_to_close.each do |prog|

      exit_attrs = FactoryGirl.create :prog_exit, {
        student_id: stu.id,
        Program_ProgCode: prog.program.id,
        ExitCode_ExitCode: (ExitCode.find_by :ExitCode =>e_code).id,
        ExitDate: exit_date,
        RecommendDate: rec_date
      }
    end

  end

  def pop_clinical_assignment(stu, teacher)
      p __method__
    
    
    start_date = Faker::Time.between(4.years.ago, Date.today)
    term = BannerTerm.current_term({
      :exact => false,
      :plan_b => :forward,
      :date => start_date
    })

    end_date = term.EndDate

    FactoryGirl.create :clinical_assignment, {
      :student_id => stu.id,
      :clinical_teacher_id => teacher.id,
      :StartDate => start_date,
      :EndDate => end_date,
      :Term => term.id
    }


  end

end