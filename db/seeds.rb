#seed.rb
require 'active_record/fixtures'

#load these records from fixtures
constants = ["banner_terms", "exit_codes", "programs", "roles", "majors", "praxis_tests"]
constants.each do |c|
  print "#{c}:"
  model = c.camelize.singularize.constantize
  if model.count == 0
    print " -> loading..."
    ActiveRecord::FixtureSet::create_fixtures(Rails.root.join("test", "fixtures"), c)
    puts "-> done!"
  else
    puts " -> data exists, skipping"
  end
end
