require 'factory_girl'
namespace :db do
  task :populate => ["db:devo:set_env", :environment] do

    Rake::Task["db:seed"].invoke

    FactoryGirl.create :admin
    FactoryGirl.create_pair :advisor
    FactoryGirl.create_pair :staff
    FactoryGirl.create_pair :stu_labor

    students = FactoryGirl.create_list :student, 100

    students.each do |s|
      #decide the fate of each student going through the program!

      paths = [true, false, nil]  #possible outcomes at each decision point


      #TODO TRANSCTIPT

      #FORM OF INTENTION
      num_forms = Faker::Number.between 1, 3 #how many forms did they do?

      (num_forms).times do
        seek_cert = Faker::Boolean.boolean
        eds_only = Faker::Boolean.boolean if !seek_cert

        FactoryGirl.create :foi, {
          student_id: s.id,
          date_completing: Faker::Time.between(4.years.ago, 3.year.ago),
          major_id: Major.all.sample.id,
          seek_cert: seek_cert,
          eds_only: eds_only
          }
      end

      #ADM_TEP
      foi = s.latest_foi
      date_apply = Faker::Time.between(3.years.ago, 2.years.ago)
      if foi.seek_cert
        #they're applying!
        term = BannerTerm.current_term(options={
          date: date_apply,
          exact: false,
          plan_b: :back})

        num_programs = Faker::Number.between(1,2)

        num_programs.times do
          admit = paths.sample

          if admit
            gpa = 2.75
            gpa_last30 = 3.0
            credits = 30

            #give them passing praxis results
            p1_tests = PraxisTest.where {}

          else
            gpa = Faker::Boolean.boolean ? 
              Faker::Number.between(0, 2) : Faker::Number.between(3, 4)
            gpa_last30 = 2.99
            credits = Faker::Boolean.boolean ? 
              Faker::Number.between(0, 29) : Faker::Number.between(30, 40)
          end

          #TODO: need to populate transcirpt
          #need methods to compute GPA and credits
          # app = FactoryGirl.create :adm_tep, {
          #   :student_id: s.id,
          #   :Program_ProgCode => Program.all.sample,
          #   :BannerTerm_BannerTerm => term.id,

          # }

        end

      end

    end
  end

  task :clean => ["db:devo:set_env", :environment] do
    puts Rails.env
    #used for cleaning the development database
    conn = ActiveRecord::Base.connection
    conn.execute("SET FOREIGN_KEY_CHECKS = 0")
    tables = conn.execute("show tables").map { |r| r[0] }
    tables.delete "schema_migrations"

    while tables.length > 0
      begin
        t = tables.slice!(0)
        conn.execute("TRUNCATE #{t}")
        puts "TRUNCATED #{t}"
      rescue ActiveRecord::StatementInvalid => e
        tables << t   #append table to end and try again later
      end
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