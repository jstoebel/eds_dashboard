namespace :deploy do

  desc "make changes to dbi library for capatability with Ruby 2.x"
  task :update_dbi do
      # update file in dbi per these instructions: http://stackoverflow.com/questions/27873121/dbi-row-delegate-behavior-between-ruby-1-8-7-and-2-1
      file_loc = "/home/stoebelj/eds_dashboard/shared/bundle/ruby/2.3.0/gems/dbi-0.4.5/lib/dbi/row.rb"
      puts "modifying #{file_loc}..."
      on roles(:app) do
        # modify the source code in place
        execute(" sed -i '212s@.*@        if RUBY_VERSION =~ \/^1\.9\/ || RUBY_VERSION =~ \/^2\/ @' #{file_loc} ")
      end
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
  after :deploy, "deploy:update_dbi"

end
