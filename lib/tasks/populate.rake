require 'factory_girl'
require 'populate_helper'
require 'faker'
include PopulateHelper
include Faker

namespace :db do
  task :populate => ["db:devo:set_env", "db:clean", :environment] do


    puts "Starting populate"
    t0 = Time.now

    Rake::Task["db:seed"].invoke

    FactoryGirl.create :admin
    advisors = FactoryGirl.create_pair :advisor
    FactoryGirl.create_pair :staff
    FactoryGirl.create_pair :stu_labor

    students = FactoryGirl.create_list :student, 100

    paths = [true, false, nil]  #possible outcomes at each decision point

    #10 sites with 3 teachers each.
    clinical_sites = FactoryGirl.create_list :clinical_site, 10
    clinical_teachers = clinical_sites.map { |site| FactoryGirl.create_list :clinical_teacher, 3 }

    students.each do |s|
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

      #FOI
      pop_fois s

      #ADM_TEP
      foi = s.latest_foi

      if foi.seek_cert
        pop_adm_tep s, paths.sample
      end

      if s.open_programs
        pop_adm_st(s, paths.sample)
      
      end

      #was student admitted to Student Teaching
      st_admissions = s.adm_st

      if st_admissions.present?
        exit_from_st(s, paths.sample)
      end

      #clinical_assignments
      num_assignments = Faker::Number.between(0, 5)
      my_teachers = clinical_teachers.shuffle.slice(0, num_assignments)

      my_teachers.map { |teacher| pop_clinical_assignment(s, teacher)}


    end #end of task

    puts "Populate complete. Time=#{Time.now - t0}"

  end

  task :clean => ["db:devo:set_env", :environment] do
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
    desc "Custom dependency to set development environment"
    task :set_env do # Note that we don't load the :environment task dependency
      Rails.env = "development"
    end
  end

end