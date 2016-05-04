require 'factory_girl'
require 'populate_helper'
include PopulateHelper

namespace :db do
  task :populate => ["db:devo:set_env", "db:clean", :environment] do


    puts "Starting populate"
    t0 = Time.now

    Rake::Task["db:seed"].invoke

    FactoryGirl.create :admin
    FactoryGirl.create_pair :advisor
    FactoryGirl.create_pair :staff
    FactoryGirl.create_pair :stu_labor

    students = FactoryGirl.create_list :student, 100

    paths = [true, false, nil]  #possible outcomes at each decision point
    
    students.each do |s|
      #decide the fate of each student going through the program

      #FOI
      pop_fois s

      #ADM_TEP
      foi = s.latest_foi

      if foi.seek_cert
        puts "lets see if they will apply to TEP"

        pop_adm_tep s, paths.sample

      end

      if s.open_programs
        # puts "should they student teach?"
        pop_adm_st(s, paths.sample)
      
      end

      #was student admitted to Student Teaching
      st_admissions = s.adm_st #.where(:STAdmitted => true)
      if st_admissions.present?
      end

      if st_admissions.present?
        exit_from_st(s, paths.sample)
      end

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