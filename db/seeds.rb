#seed.rb
require 'active_record/fixtures'

#load these records from fixtures
constants = ["banner_terms", "exit_codes", "programs", "roles"]
constants.each do |c|
    ActiveRecord::FixtureSet::create_fixtures(Rails.root.join("test", "fixtures"), c)
end