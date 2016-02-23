namespace :db do
    task :load_devo do


        fixtures_dir = Rails.root + "test/fixtures"
        black_listed = ['adm_teps.yml', 'adm_sts.yml']
        fixtures = Dir["#{fixtures_dir}/**/*.yml"].map {|f| File.basename f, ".*"}
        (fixtures - black_listed).each do |i|
            Rake::Task["db:fixtures:load FIXTURES=#{i}"]
            puts "loaded #{i}"
        end

        # Rake::Task["db:fixtures:load FIXTURES=#{fixtures.join(",")}"]


    end
end