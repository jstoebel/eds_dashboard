require 'factory_girl'
namespace :db do
  task :populate => :environment do
    Rake::Task["db:seed"].invokerails
  end

  task :clean => :environment do

    #this is the order in which to do the deletion
    entities = %w(AdvisorAssignment TepAdvisor User AdmTep StudentFile Student)

    entities.each do |e|
        e.constantize.delete_all
    end
  end
end