namespace :db do
    task :load_devo => :environment do

        Rake::Task["db:fixtures:load"].invoke
        #Ideally I could not load the black_listed fixtures, but since I can't work this out I am simply deleting their data afterwards

        black_listed = ['adm_sts', 'student_files'] #these records point to files that won't exist in development
    
        black_listed.each do |b|
            model = b.classify.constantize
            model.delete_all
        end
    end
end