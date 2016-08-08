namespace :db do
  task :load_legacy_data => :environment do
    legacy_data_file = Rails.root.join("../eds_move/secure_seed")
    if File.exists?(legacy_data_file)
      ActiveRecord::Base.connection.execute(IO.read(legacy_data_file))
    else
      puts "Legacy data file not found at #{legacy_data_file}"
    end
  end
end
