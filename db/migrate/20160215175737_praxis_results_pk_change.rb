class PraxisResultsPkChange < ActiveRecord::Migration
  def up

    # #add Bnum, TestCode and TestDate to praxis_subtest_results
    # change_table :praxis_subtest_results do |t|
    #   t.string :praxis_results_Student_Bnum, limit: 9
    #   t.string :praxis_results_TestCode, limit: 45
    #   t.datetime :praxis_results_TestDate
    # end

    # #drop praxis_subtest_results fk

    # execute %q(ALTER TABLE `praxis_subtest_results` 
    #   DROP FOREIGN KEY `fk_praxis_subtest_results_praxis_results`;)

    # execute %q(ALTER TABLE `praxis_subtest_results` 
    #   DROP COLUMN `praxis_results_TestID` ;)
   
    # # remove TestID
    # change_table :praxis_results do |t|
    #   t.remove :TestID
    # end

    # # composite pk = Bnum+TestCode+TestDate
    # execute %q(ALTER TABLE `praxis_results` 
    # ADD PRIMARY KEY (`Bnum`, `TestCode`, `TestDate`);)

    # #hook up new fks praxis_results_subtest -> praxis_results
    # execute %q(ALTER TABLE `praxis_subtest_results` 
    # ADD CONSTRAINT `fk_praxis_subtest_results_praxis_results`
    #   FOREIGN KEY (`praxis_results_Student_Bnum`, `praxis_results_TestCode`, `praxis_results_TestDate`)
    #   REFERENCES `praxis_results` (`Bnum`, `TestCode`, `TestDate`)
    #   ON DELETE RESTRICT
    #   ON UPDATE RESTRICT;)


    # # add AltID to praxis_results
    # execute %q(ALTER TABLE `praxis_results` 
    #   ADD COLUMN `AltID` INT NULL AUTO_INCREMENT AFTER `Pass`,
    #   ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC);)

  end

  def down
  # # #   #remove AltID and add TestID
  #   change_table :praxis_results do |t|
  #     t.remove :AltID
  #     t.string :TestID, limit: 45
  #   end

  # #   #subtest results: reverse column change
  #   change_table :praxis_subtest_results do |t|
  #     t.string :praxis_results_TestID, limit: 25
  #   end

  #   execute %q(ALTER TABLE `praxis_subtest_results` 
  #     DROP FOREIGN KEY `fk_praxis_subtest_results_praxis_results`;)

  #   execute %q(ALTER TABLE `praxis_subtest_results` 
  #     DROP COLUMN `praxis_results_TestDate`,
  #     DROP COLUMN `praxis_results_TestCode`,
  #     DROP COLUMN `praxis_results_Student_Bnum`,
  #     DROP INDEX `fk_praxis_subtest_results_praxis_results` ;)
    

  #   execute %q(ALTER TABLE `praxis_results` 
  #   DROP PRIMARY KEY,
  #   ADD PRIMARY KEY (`TestID`);)

  #   #hook up old fk
  #   execute %q(ALTER TABLE `praxis_subtest_results` 
  #   ADD CONSTRAINT `fk_praxis_subtest_results_praxis_results`
  #     FOREIGN KEY (`praxis_results_TestID`)
  #     REFERENCES `praxis_results` (`TestID`)
  #     ON DELETE RESTRICT
  #     ON UPDATE RESTRICT;)

  end

end
