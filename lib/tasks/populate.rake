require 'factory_girl'
require 'database_cleaner'
namespace :db do
  task :populate => :environment do
    Rake::Task["db:seed"].invoke

    adm = FactoryGirl.create :adm_tep, 
      {   :Program_ProgCode => Program.first.id,
          :BannerTerm_BannerTerm => BannerTerm.current_term.id
      }

    stu = adm.student
    FactoryGirl.create :adm_st, 
      {
        :Student_Bnum => stu.id,
        :BannerTerm_BannerTerm => adm.BannerTerm_BannerTerm
      }

    stu.EnrollmentStatus = "Graduation"
    stu.save
    puts stu.inspect
    FactoryGirl.create :prog_exit,
      {
        :Student_Bnum => stu.id,
        :Program_ProgCode => adm.program.id,
        :ExitCode_ExitCode => "1849",
        :ExitTerm => adm.BannerTerm_BannerTerm
      }


    puts "number of exits #{ProgExit.all.size}"

  end

  task :clean => :environment do

    #this is the order in which to do the deletion
    entities = %w(AdvisorAssignment TepAdvisor User AdmTep AdmSt StudentFile Student)

    entities.each do |e|
        e.constantize.delete_all
    end
  end
end