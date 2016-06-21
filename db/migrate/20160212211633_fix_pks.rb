class FixPks < ActiveRecord::Migration
    #fix the type and ai status of all pks
  def up

    #change exit_codes to string and remove AI
    execute "ALTER TABLE `exit_codes` CHANGE COLUMN `ExitCode` `ExitCode` VARCHAR(5) NOT NULL;"

    execute "ALTER TABLE `praxis_results` CHANGE COLUMN `TestID` `TestID` VARCHAR(25) NOT NULL"

    execute "ALTER TABLE `praxis_subtest_results` CHANGE COLUMN `SubTestID` `SubTestID` VARCHAR(25) NOT NULL ;"

    execute "ALTER TABLE `praxis_tests` CHANGE COLUMN `TestCode` `TestCode` VARCHAR(45) NOT NULL ;"
 
    execute "ALTER TABLE `praxis_updates` CHANGE COLUMN `ReportDate` `ReportDate` TIMESTAMP NOT NULL DEFAULT current_timestamp() ;"

    #drop the pk first so we can remove the column
    execute "ALTER TABLE `prog_exits`  DROP COLUMN `id`;"
    execute "ALTER TABLE `prog_exits` ADD PRIMARY KEY (`Student_Bnum`, `Program_ProgCode`);"

    execute "ALTER TABLE `roles` CHANGE COLUMN `idRoles` `idRoles` INT(11) NOT NULL ;"

    execute "ALTER TABLE `tep_advisors` CHANGE COLUMN `AdvisorBnum` `AdvisorBnum` VARCHAR(9) NOT NULL ;"

    execute "ALTER TABLE `transcript` CHANGE COLUMN `crn` `crn` VARCHAR(45) NOT NULL ;"

    execute "ALTER TABLE `users` CHANGE COLUMN `UserName` `UserName` VARCHAR(45) NOT NULL ;"

  end

  def down

    
    change_column :users, :UserName, :int, :null => false
    change_column :transcript, :crn, :int, :null => false
    change_column :tep_advisors, :AdvisorBnum, :string, :null => false
    change_column :roles, :idRoles, :string #THIS IS A GUESS!
    execute %q(ALTER TABLE `eds_development`.`prog_exits` 
    ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT,
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (`id`);)
    change_column :praxis_updates, :ReportDate, :integer
    change_column :praxis_tests, :TestCode, :integer
    change_column :praxis_subtest_results, :SubTestID, :integer
    change_column :praxis_results, :TestID, :integer
    change_column :exit_codes, :ExitCode, :integer



    # remove_foreign_key :prog_exits, :name => "fk_Exit_ExitCode"
    # execute "ALTER TABLE `exit_codes` CHANGE COLUMN `ExitCode` `ExitCode` INT NOT NULL AUTO_INCREMENT ;"

    # execute "ALTER TABLE `praxis_results` CHANGE COLUMN `TestID` `TestID` INT NOT NULL AUTO_INCREMENT ;"

    # execute "ALTER TABLE `praxis_subtest_results` CHANGE COLUMN `SubTestID` `SubTestID` INT NOT NULL AUTO_INCREMENT ;"

    # execute "ALTER TABLE `praxis_tests` CHANGE COLUMN `TestCode` `TestCode` INT NOT NULL AUTO_INCREMENT ;"

    # execute "ALTER TABLE `praxis_updates` CHANGE COLUMN `ReportDate` `ReportDate` INT NOT NULL AUTO_INCREMENT ;"

    # execute "ALTER TABLE `prog_exits` DROP PRIMARY KEY;"

    # execute "ALTER TABLE `prog_exits` ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT FIRST,ADD PRIMARY KEY (`id`);"

    execute "ALTER TABLE `roles` CHANGE COLUMN `idRoles` `idRoles` INT NOT NULL AUTO_INCREMENT ;"

    execute "ALTER TABLE `tep_advisors` CHANGE COLUMN `AdvisorBnum` `AdvisorBnum` INT NOT NULL AUTO_INCREMENT ;"

    execute "ALTER TABLE `transcript` CHANGE COLUMN `crn` `crn` INT NOT NULL AUTO_INCREMENT ;"

    execute "ALTER TABLE `transcript` CHANGE COLUMN `crn` `crn` INT NOT NULL AUTO_INCREMENT ;"

  end
end
