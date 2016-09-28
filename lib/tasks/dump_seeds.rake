task :dump_seeds => :environment do
  constants = ["BannerTerm", "ExitCode", "Program", "Role", "Major",
    "PraxisTest"].join(", ")

  ENV['MODELS'] = constants
  Rake::Task["db:seed:dump"].invoke
end
