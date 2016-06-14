namespace :db do
    task :test_fixtures => :environment do
        #get all fixture names

        all_fixtures = Dir["test/fixtures/*"].select{|f| /yml/.match(f)}.map {|f| File.basename f, ".*"}

        all_fixtures.each do |f|
            p "trying to load #{f}"
            ActiveRecord::FixtureSet::create_fixtures(Rails.root.join("test", "fixtures"), f)
        end

        p "successfully loaded all fixtures"
    end
end