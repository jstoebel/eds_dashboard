# EDS Dashboard

An advisor dashboard for Berea College's Teacher Education Program

### Background

The Education Studies Department at Berea College maintains state and federal certification by providing an abundance of evidence that we prepare strong K-12 teachers. This project began in 2015 when I was tasked with maintaining a good deal of student achievement data to support this goal. The data system at the time consisted of several disparate Access Databases, Excel Spreadsheets, paper records, and way too much stuff stored in people's brains! Wanting to move all of our data and business logic into a single place I created this Rails application to handle all of our critical workflows and provide much needed data to our staff and faculty.

### Setup and Configuration

 - install dependencies `bundle install`

 - This project connects with our Banner our enterprise database (Oracle). If your machine doesn't have Oracle client installed, use 'bundle install --without cs_c9_exclude'

 - Also: this app does not ship with a database.yml file. Several folks on our team
develop in a cloud based environment and have specific requirements for
database configuration. 

Like all applications at Berea College, we run MySQL in production. If your development environment allows it, set up MySQL and use this as your `database.yml`

```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: edsaccess
  password: <%= ENV["EDSACCESS_PW"] %>

development:
  <<: *default
  database: eds_development

test:
  <<: *default
  database: eds_test
```

If you want to set up a minimal development environment
drop the following into `config/database.yml`

```
default: &default
  adapter: sqlite3
  encoding: utf8
  pool: 5

development:
  <<: *default
  database: eds_development

test:
  <<: *default
  database: eds_test
```

### Database initialization
 - To build the schema from scratch run `rake db:schema:load`
 - run `rake db:seed` to load constant data from fixtures. This will load `banner_terms` , `exit_codes`, `programs`, `roles`, `majors`, `praxis_tests`
 - run `rake db:populate` to load sample data into the development database. Note that this will truncate the entire development database and remove any attached files from `public/student_files/development`. Note that this script will refuse to execute against production (not that you would want to!)

### Related external services
This app regularly connects to two external services to update its own data:

 - Banner, Berea College's enterprise system.
 - Education Testing Service, which provides weekly student test results (when available.) `config/schedule.rb` will configure a cron task to hit up these services once per day.

### Testing
 - This app uses Minitest for all tests.
 - All commits to this app are built remotely using the Continuous Integration Service CodeShip.

### Deployment instructions

 - Berea College deploys this app in an Ubuntu VM in our data center.
 - Capistrano is used for all deployments: `cap production deploy`!
 - For production the following secrets need to be stored OUTSIDE OF THE APP in `~/.eds_secrets.yml`
	 - __secrets\_key\_base__ under the key `ENV["SECRET_KEY_BASE"]` (run rake secrets to generate one)
	 - __database password__
	 - __banner user name and password__
   
### User help

A growing number of help files can be found [here](app/views/helps). For convenience you can already read them inside the app. Just click the help button at the top of the nav bar.

### Blog Articles

I've been blogging about this project and what I've learned about Ruby / Rails along the way:

[Notes on Upgrading to Rails 5](http://www.jstoebel.com/upgrading-the-eds-dashobard-to-rails-5)
[Intro to Fakes, Mocks and Stubs](http://www.jstoebel.com/a-no-frills-jump-into-fakes-mocks-and-stubs/)
[Automating Gem Security Warnings](http://www.jstoebel.com/automate-gem-security-warnings-with-bundle-audit)
[Seriously, Use Factories and Not Fixtures: A Survivor's Story](http://www.jstoebel.com/seriously-use-factories-and-not-fixtures-a-survivors-story)
[Using and Securing Rails Admin](http://www.jstoebel.com/using-and-securing-rails_admin/)
[Think twice before you change your Rails primary key data type](http://www.jstoebel.com/never-change-your-rails-primary-key-data-type)
[Setting Up Capistrano](http://www.jstoebel.com/deploying-eds_dashboard-with-capistrano/)
