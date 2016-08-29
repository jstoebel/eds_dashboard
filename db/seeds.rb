#seed.rb
require 'active_record/fixtures'

#load these records from fixtures
constants = ["banner_terms", "exit_codes", "programs", "roles", "majors", "praxis_tests"]
constants.each do |c|
    ActiveRecord::FixtureSet::create_fixtures(Rails.root.join("test", "fixtures"), c)
end

# alter each id to match TestCode
# PraxisTest.all.each do |pt|
#   pt.id = pt.TestCode.to_i
#   pt.save!
# end
