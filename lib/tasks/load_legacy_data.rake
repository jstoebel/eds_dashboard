# BROKEN. CURRENTLY IT THROWS A SYNTAX ERROR.
# INSTEAD I AM FALLING BACK ON LOADING THE FILE STRAIGHT FROM MYSQL

require 'yaml'
namespace :db do
  task :load_legacy_data => :environment do

    legacy_data_file = Rails.root.join("../eds_move/secure_seed", "freeze_data_for_eds.sql")
    if File.exists?(legacy_data_file)
      config = YAML.load_file(Rails.root.join('config', 'database.yml'))
      db = config[Rails.env]['database']
      ActiveRecord::Base.connection.execute("USE #{db}")
      ActiveRecord::Base.connection.execute(IO.read(legacy_data_file))
    else
      fail "Legacy data file not found at #{legacy_data_file}"
    end
  end
end
