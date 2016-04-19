class AllPksInts < ActiveRecord::Migration
  def up

    # students (make Bnum a unique )

    execute %q(ALTER TABLE `students` 
    DROP INDEX `AltID_UNIQUE`,
    DROP COLUMN `AltID`,
    ADD UNIQUE INDEX `Bnum_UNIQUE` (`Bnum` ASC),
    DROP PRIMARY KEY;
    )
    add_column :students, :id, :primary_key, :first => true

    # tep_advisor (id with Bnum as unique index)
    execute %q(ALTER TABLE `tep_advisors` 
    DROP PRIMARY KEY;
    )
    add_column :tep_advisors, :id, :primary_key, :first => true

    # advisor assignments
    drop_table :advisor_assignments

    create_table :advisor_assignments do |t|
        t.integer :student_id
        t.integer :tep_advisor_id
    end


    # EXIT CODES

    #drop the forign key on prog_exits

    remove_foreign_key :prog_exits, :name => "fk_Exit_ExitCode"

    #alter the table
    execute %q(ALTER TABLE `exit_codes` 
    ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT FIRST,
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (`id`);
    )

    #change prog_exits to have an int column
    change_column :prog_exits, :ExitCode_ExitCode, :integer

    #add the forin key to reference the new pk
    add_foreign_key :prog_exits, :exit_codes, :column => "ExitCode_ExitCode"

    # PRAXIS_RESULTS (set unique index across student/praxis_test and test_date, you'll need to use execute)
    
    #remove fks referencing praxis_results

    # #remove AltID and make id AI int
    execute %q(ALTER TABLE `praxis_results` 
    DROP INDEX `AltID_UNIQUE`,
    DROP COLUMN `AltID`,
    CHANGE COLUMN `id` `id` INT NOT NULL AUTO_INCREMENT
    ;)

    # #add a fk to sub_tests

    change_column :praxis_subtest_results, :praxis_result_id, :integer
    add_foreign_key :praxis_subtest_results, :praxis_results

    #make unique index across three fks
    add_index :praxis_results, [:student_id, :praxis_test_id, :test_date], {unique: true, :name => "index_by_stu_test_date"}

    # PRAXIS_TEST (TestCode should be unique but not pk)

    #remove fk dependancies
    remove_foreign_key :praxis_results, :name => "fk_praxis_results_praxis_tests"
    change_column :praxis_results, :praxis_test_id, :integer


    remove_foreign_key :praxis_prep, :name => "fk_PraxisPrep_PraxisTest"
    change_column :praxis_prep, :PraxisTest_TestCode, :integer
    
    #remove pk
    execute %q(ALTER TABLE `praxis_tests` 
    DROP PRIMARY KEY ,
    ADD UNIQUE INDEX `TestCode_UNIQUE` (`TestCode` ASC);)

    #add id as pk
    add_column :praxis_tests, :id, :primary_key, :first => true

    #add fks
    add_foreign_key :praxis_prep, :praxis_tests, :column => :PraxisTest_TestCode
    add_foreign_key :praxis_results, :praxis_tests

    # praxis_updates (add id)
    # prog_exit single id with bnum/program as unique index
    # programs need an id ProgCode is unique
    # transcript

  end

  def down

    # PRAXIS_TEST

    # remove_foreign_key :praxis_results, :praxis_tests
    # remove_foreign_key :praxis_prep, :column => :PraxisTest_TestCode

    # execute %q(ALTER TABLE `eds_development`.`praxis_tests` 
    # DROP PRIMARY KEY,
    # DROP COLUMN `id`,
    # ADD PRIMARY KEY (`TestCode`);
    # )

    # change_column :praxis_prep, :PraxisTest_TestCode, :string
    # add_foreign_key "praxis_prep", "praxis_tests", name: "fk_PraxisPrep_PraxisTest", column: "PraxisTest_TestCode", primary_key: "TestCode"

    # change_column :praxis_results, :praxis_test_id, :string
    add_foreign_key "praxis_results", "praxis_tests", name: "fk_PraxisResult_PraxisTest", primary_key: "TestCode"

    # PRAXIS_RESULTS
    remove_index :praxis_results, :name => "index_by_stu_test_date"
    remove_foreign_key :praxis_subtest_results, :praxis_results

    change_column :praxis_subtest_results, :praxis_result_id, :string

    execute %q(ALTER TABLE `praxis_results` 
    CHANGE COLUMN `id` `id` VARCHAR(45) NOT NULL ,
    ADD COLUMN `AltID` INT NOT NULL AUTO_INCREMENT ,
    ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC);
    )

    # EXIT CODES
    remove_foreign_key :prog_exits, :column => "ExitCode_ExitCode"
    change_column :prog_exits, :ExitCode_ExitCode, :string
    execute %q(ALTER TABLE `exit_codes` 
    DROP PRIMARY KEY,
    DROP COLUMN `id`,
    ADD PRIMARY KEY (`ExitCode`);
    )
    add_foreign_key "prog_exits", "exit_codes", name: "fk_Exit_ExitCode", column: "ExitCode_ExitCode", primary_key: "ExitCode"

    # ADVISOR ASSIGNMENTS
    
    drop_table :advisor_assignments

    create_table "advisor_assignments", id: false, force: true do |t|
      t.string "Student_Bnum",             limit: 9, null: false
      t.string "tep_advisors_AdvisorBnum", limit: 9, null: false
    end

    #TEP_ADVISORS
    execute %q(ALTER TABLE `eds_development`.`tep_advisors` 
    DROP COLUMN `id`,
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (`AdvisorBnum`);
    )


    #STUDENTS
    remove_column :students, :id

    execute %q(ALTER TABLE `students` 
    ADD COLUMN `AltID` INT NULL AUTO_INCREMENT AFTER `CPO`,
    ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC),
    ADD PRIMARY KEY (`Bnum`),
    DROP INDEX `Bnum_UNIQUE` ;
    )
  end
end
