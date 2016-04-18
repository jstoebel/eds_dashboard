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


    # exit codes
    # praxis_results (set unique index across student/praxis_test and test_date, you'll need to use execute)
    # praxis_test (TestCode should be unique but not pk)
    # praxis_updates (add id)
    # prog_exit single id with bnum/program as unique index
    # programs need an id ProgCode is unique
    # transcript

  end

  def down

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
