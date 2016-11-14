# If a :path is not set it will default to the directory in which whenever was executed.
# :environment_variable will default to 'RAILS_ENV'.
# :environment will default to 'production'.
# :output will be replaced with your output redirection settings which you can read more about here:
# http://github.com/javan/whenever/wiki/Output-redirection-aka-logging-your-cron-jobs

set :output, 'log/production.log'
set :path, "/home/stoebelj/eds_dashboard/current"
env :PATH, ENV['PATH']

every 1.day, :at => '3:30 am' do
  rake "full_banner_update"
  rake "update_praxis[true]"
end
