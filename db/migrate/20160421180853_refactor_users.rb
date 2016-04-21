class RefactorUsers < ActiveRecord::Migration
  def up

    remove_foreign_key :tep_advisors, :name => "fk_tep_advisors_users"
    execute %q(ALTER TABLE `users` 
    DROP PRIMARY KEY ,
    ADD UNIQUE INDEX `UserName_UNIQUE` (`UserName` ASC) ;)

    add_column :users, :id, :primary_key, :first => true

    remove_column :tep_advisors, :username
    add_column :tep_advisors, :user_id, :integer
    add_foreign_key :tep_advisors, :users

  end

  def down

    remove_foreign_key :tep_advisors, :users
    remove_column :tep_advisors, :user_id
    add_column :tep_advisors, :username, :string
    remove_column :users, :id

    execute %q(ALTER TABLE `users`
    DROP INDEX `UserName_UNIQUE` ,
    ADD PRIMARY KEY (`UserName`) ;)

    add_foreign_key "tep_advisors", "users", name: "fk_tep_advisors_users" ,column: "username", primary_key: "UserName"

  end
end
