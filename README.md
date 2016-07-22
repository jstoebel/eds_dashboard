## EDS Dashboard

### Versions
Ruby version: 2.1, Rails Version 4.1

### Configuration
	install dependencies `bundle install`

	Add database.yml file (see repo wiki)

### Data migration

- In windows: create a dump.sql file from access using bullzip. 
- Make a python script to read these data and populate to the existing production database.
- Current TEP advisors need to be added (not included since they contain B#s)
- Dump the data to a .sql file: `mysqldump -u edsaccess -p eds_development --ignore-table=eds_development.schema_migrations --no-create-info  > ~/eds_move/bootstrap_secure/freeze_data_for_eds.sql`
-Load data into production!




### Database initialization
 - To build the schema from scratch run `rake db:schema:load`
 - run `rake db:seed` to load constant data from fixtures. This will load `banner_terms` , `exit_codes`, `programs` and `roles`
 - run `rake db:populate` to load sample data into the development database. Note that this will truncate the entire development database.

### connecting to Banner
This app depends on a connection to Banner to update its native database natively. To do that you will need [dbi](http://ruby-dbi.rubyforge.org/rdoc/index.html) [oci8](http://www.rubydoc.info/github/kubo/ruby-oci8/file/docs/install-on-osx.md). OCI8 requires a bit more set up. Please read the docs to get started.

Also dbi needs a small tweak to support ruby 2. Make the changed specified [here](http://stackoverflow.com/questions/27873121/dbi-row-delegate-behavior-between-ruby-1-8-7-and-2-1) 

### Testing
 -  This uses Minitest for all tests.
 - All commits to this app are built in a testing enviornment using CodeShip.

* Deployment instructions

 - For production the following secrets need to be stored in session information. A bash profile is a good place.
 - secrets\_key\_base under the key `ENV["SECRET_KEY_BASE"]` (run rake secrets to generate one)
 - database password
 - banner user name and password