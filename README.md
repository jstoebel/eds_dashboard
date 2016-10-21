## EDS Dashboard


An advisor dashboard for Berea College's Teacher Education Program

### Versions
Ruby version: 2.1, Rails Version 4.1

### Configuration

install dependencies `bundle install`

This app does not ship with a database.yml file. Several folks on our team
develop in a cloud based environment and have specific requirements for
database configuration. If you want to set up a minimal development environment
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
 - run `rake db:seed` to load constant data from fixtures. This will load `banner_terms` , `exit_codes`, `programs` and `roles`
 - run `rake db:populate` to load sample data into the development database. Note that this will truncate the entire development database and remove any attached files from `public/student_files/development`

### connecting to Banner
This app depends on a connection to Banner to update its database. To do that you will need [dbi](http://ruby-dbi.rubyforge.org/rdoc/index.html) [oci8](http://www.rubydoc.info/github/kubo/ruby-oci8/file/docs/install-on-osx.md). OCI8 requires a bit more set up. Please read the docs to get started.

Also `dbi` needs a small tweak to support ruby 2. Make the changed specified [here](http://stackoverflow.com/questions/27873121/dbi-row-delegate-behavior-between-ruby-1-8-7-and-2-1). For rbenv the file to edit is here: `~/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/dbi-0.4.5/lib/dbi`

### Testing
 - This app uses Minitest for all tests.
 - All commits to this app are built remotely using CodeShip.

### Deployment instructions

 - Berea College deploys this app in an Ubuntu VM in our data center.
 - For production the following secrets need to be stored OUTSIDE OF THE APP in `~/.eds_secrets.yml`
	 - __secrets\_key\_base__ under the key `ENV["SECRET_KEY_BASE"]` (run rake secrets to generate one)
	 - __database password__
	 - __banner user name and password__