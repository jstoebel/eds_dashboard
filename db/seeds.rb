#seed.rb
require 'active_record/fixtures'


if ["development", "test"].include? Rails.env
  #load these records from fixtures
  constants = ["banner_terms", "exit_codes", "programs", "roles", "majors", "praxis_tests"]
  constants.each do |c|

    model = c.camelize.singularize.constantize
    if model.count == 0
      print "loading #{c}..."
      ActiveRecord::FixtureSet::create_fixtures(Rails.root.join("db", "seed"), c)
      puts "-> done!"
    end
  end
else
  raise "seeds.rb may only be run in development or test enviornment"
end
