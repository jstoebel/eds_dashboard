require 'active_record/fixtures'
namespace :db do
  task :load_secure_seed => :environment do
    #loads yaml file of of existing data that can't be shared in source control
    secure_constants = ["tep_advisors", "users"]
    secure_constants.each do |sc|
        ActiveRecord::FixtureSet::create_fixtures(Rails.root.join("db", "seed", "secure_seed"), sc)
    end
  end
end
