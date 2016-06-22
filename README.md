## EDS Dashboard

* Ruby version: 2.1, Rails Version 4.1

* System dependencies

* Configuration
	install dependencies:
		bundle install

	Add database.yml file (see repo wiki)

* Database migration

	Initial migration
	In windows: 
		create a dump.sql file from access using bullzip

	In Linux (local machine)

	DATA: 
	1) create movedb from dump.sql
	2) using python script, connect to edsdata and migrate data to database called eds.

* Updates to the schema:
	- We are using migrations to properly version the schema. When pushing new migrations be sure to also push the most up to data schema.rb.


* Database initialization
	- To build the schema from scratch run `rake db:schema:load`
	- run `rake db:seed` to load constant data from fixtures. This will load `banner_terms` , `exit_codes`, `programs` and `roles`
    - run `rake db:populate` to load sample data into the development database. Note that this will truncate the entire development database.

* connecting to Banner
This app depends on a connection to Banner to update its native database natively. To do that you will need [dbi](http://ruby-dbi.rubyforge.org/rdoc/index.html) [oci8](http://www.rubydoc.info/github/kubo/ruby-oci8/file/docs/install-on-osx.md). OCI8 requires a bit more set up. Please read the docs to get started.

* Testing

    - This uses Minitest for all tests.
    - All commits to this app are built in a testing enviornment using CodeShip.

* Deployment instructions

    - For production the following secrets need to be stored in session information. A bash profile is a good place.
    - secrets\_key\_base under the key `ENV["SECRET_KEY_BASE"]` (run rake secrets to generate one)
    - database password