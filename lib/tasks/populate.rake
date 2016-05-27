require 'factory_girl'
require 'populate_helper'
require 'faker'
include PopulateHelper
include Faker

namespace :db do
  task :populate => ["db:devo:set_env", "db:clean", :environment] do


    t0 = Time.now
    puts "[#{t0}] Starting populate"

    Rake::Task["db:seed"].invoke
    puts "Seeds added."

    FactoryGirl.create(:admin, {
          UserName: "dev_admin",
          FirstName: "Dev",
          LastName: "Admin",
          Email: "devadmin@test.com",
          Roles_idRoles: 1

        })
    admin_tep_profile = FactoryGirl.create :tep_advisor, {:user_id => 1}
    
    advisors = FactoryGirl.create_pair :advisor
    FactoryGirl.create_pair :staff
    FactoryGirl.create_pair :stu_labor

    students = FactoryGirl.create_list :student, 50

    paths = [true, false, nil]  #possible outcomes at each decision point

    #10 sites with 3 teachers each.
    clinical_sites = FactoryGirl.create_list :clinical_site, 10
    clinical_teachers = clinical_sites.map{ |site| FactoryGirl.create_list :clinical_teacher, 3 }.flatten

    puts "creating data for students..."
    students.each do |s|

      print "#{s.name_readable}"
      #decide the fate of each student going through the program

      # ADVISOR ASSIGNMENTS
      # assign them to one or both advisors

      num_advisors = Faker::Number.between(1, 2)

      my_advisors = advisors.shuffle.slice(0, num_advisors)

      my_adv_assignments = my_advisors.map { |adv| AdvisorAssignment.create(
        { :student_id => s.id,
          :tep_advisor_id => adv.tep_advisor.id
        })
      }

      #also, everyone needs to have dev_admin as an advisor
      AdvisorAssignment.create({
          :student_id => s.id,
          :tep_advisor_id => admin_tep_profile.id
        })


      #FOI
      pop_fois s

      #PRAXIS_PRACTICE

      if Boolean.boolean 0.3

        (1..3).each do |i|

          test_record = PraxisTest.find_by :TestCode => "57#{i}2"

          passing = Boolean.boolean

          practice_params = {
            :student_id => s.id,
            :PraxisTest_TestCode => test_record.id,
            :RemediationRequired => passing,
            :Notes => Lorem.paragraph
          }

          practice_params.merge({:RemediationComplete => Boolean.boolean}) if !passing

          FactoryGirl.create :praxis_prep, practice_params

        end

      end

      #ADM_TEP
      foi = s.latest_foi

      if foi.seek_cert
        pop_adm_tep s, paths.sample
      else
        #give them the course work anyway.

        pop_transcript s, 12, 3.0, 4.years.ago, Date.today
      end

      #ADM_ST
      if s.open_programs
        s.Classification = "Senior"
        s.save
        pop_adm_st(s)
      end

      #was student admitted to Student Teaching
      st_admissions = s.adm_st

      if st_admissions.present?
        s.EnrollmentStatus = "Graduation"
        s.save
        exit_from_st(s, paths.sample)
      end

      #clinical_assignments 
      # 30% chance of having clinical_assignments
      if Boolean.boolean 0.3

        num_assignments = Faker::Number.between(0, 5)
        my_teachers = clinical_teachers.shuffle.slice(0, num_assignments)
        my_teachers.map { |teacher| pop_clinical_assignment(s, teacher)}

      end


      #ISSUES AND UPDATES
      if Boolean.boolean 0.3


        #I'm not sure why I can't pass a student_id into the issue factory. As a workaround,
        # I am using .build and then calling .save
        num_issues = Faker::Number.between(0, 3)
        my_issues = num_issues.times.map {|n| (FactoryGirl.build :issue, { :student_id => s.id, :tep_advisors_AdvisorBnum => my_advisors.sample.id})}
        my_issues.each {|n| n.save}

        my_updates = my_issues.map {|iss| FactoryGirl.create_list :issue_update, Faker::Number.between(1,3), 
          { :Issues_IssueID => iss.id,
            :tep_advisors_AdvisorBnum => my_advisors.sample.id
          }
        }

      end

      puts " -> done."
    end 
    t1 = Time.now
    puts "[#{t1}]Populate complete. Time=#{t1 - t0}"

  end #end of task

  task :clean => ["db:devo:set_env", "db:devo:clean_dev_files", :environment] do
    #used for cleaning the development database
    puts "Truncating #{Rails.env} database"
    conn = ActiveRecord::Base.connection
    tables = conn.execute("show tables").map { |r| r[0] }
    tables.delete "schema_migrations"
    
    conn.execute("SET FOREIGN_KEY_CHECKS = 0")

    tables.each do |t|
      conn.execute("TRUNCATE #{t}")
    end

    conn.execute("SET FOREIGN_KEY_CHECKS = 1")
  
  end


  namespace :devo do
    task :set_env do # Note that we don't load the :environment task dependency
      desc "Set development environment"
      Rails.env = "development"
    end

    task :clean_dev_files do
      desc "remove public/student_files/development"

        sh "rm -rf #{Rails.root}/public/student_files/development"
    end

  end

end