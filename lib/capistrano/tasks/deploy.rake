namespace :deploy do

  desc "make changes to dbi library for capatability with Ruby 2.x"
  task :update_dbi do
      puts "HELLO FROM UPDATE_DBI"
      exit # exiting for now
  end

  desc "Makes sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  before :deploy, "deploy:check_revision"
  before :deply, "deploy:update_dbi"

end
