## EDS Dashboard

* Ruby version: 2.1, Rails Version 4.1

* System dependencies

* Configuration
	install dependencies:
		bundle install

* Database migration

	Initial migration
	In windows: 
		create a dump.sql file from access using bullzip

	In Linux (local machine)

	DATA: 
	1) create movedb from dump.sql
	2) using python script, connect to edsdata and migrate data to database called eds.

* Updates to the schema:
	- We are using migrations to keep properly version the schema. Run `rake db:migrate` to get the schema in the most current version. When pushing new migrations be sure to also push the most up to data schema.rb.


* Database initialization
	- To build the schema from scratch `rake db:schema:load` might not run properly or at all. You might need to drop the database and run all migrations.
	- run `rake db:seed` to load constant data from fixtures. This will load `banner_terms` , `exit_codes`, `programs` and `roles`

* Testing

	All commits to this app are built in a testing enviornment using CodeShip.

* Deployment instructions

	The following secrets need to be stored in session information. A bash profile is a good place.
	* secrets\_key\_base under the key `ENV["SECRET_KEY_BASE"]` (run rake secrets to generate one)
	* database password
		