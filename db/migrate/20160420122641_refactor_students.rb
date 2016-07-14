class RefactorStudents < ActiveRecord::Migration
  def up
    #===========
    #STUDENTS (make Bnum a unique )
    #===========
    execute %q(ALTER TABLE `students`
    DROP INDEX `AltID_UNIQUE`,
    DROP COLUMN `AltID`,
    ADD UNIQUE INDEX `Bnum_UNIQUE` (`Bnum` ASC),
    DROP PRIMARY KEY;
    )
    add_column :students, :id, :primary_key, :first => true

    #for each of these tables:
        #drop the fk pointing to students and its column
        # create a new column: student_id
        #create a new fk to point to new students.id

    #adm_st
    remove_foreign_key :adm_st, :name => "fk_AdmST_Student"
    remove_column :adm_st, :Student_Bnum
    add_column :adm_st, :student_id, :integer, :first => true, :null => false
    add_foreign_key :adm_st, :students

    #adm_tep
    remove_foreign_key :adm_tep, :name => "fk_AdmTEP_Student"
    remove_column :adm_tep, :Student_Bnum
    add_column :adm_tep, :student_id, :integer, :first => true
    add_foreign_key :adm_tep, :students

    # advisor_assignments -> covered in later migration?

    # clinical_assignments
    remove_foreign_key :clinical_assignments, :name => "fk_ClinicalAssignments_Student"
    remove_column :clinical_assignments, :Bnum
    add_column :clinical_assignments, :student_id, :integer, :first => true, :null => false
    add_foreign_key :clinical_assignments, :students

    # employment
    remove_foreign_key :employment, :name => "fk_Employment_Student"
    remove_column :employment, :Student_Bnum
    add_column :employment, :student_id, :integer, :first => true, :null => false
    add_foreign_key :employment, :students

    # forms_of_intention
    remove_foreign_key :forms_of_intention, column: :student_id
    change_column :forms_of_intention, :student_id, :integer
    add_foreign_key :forms_of_intention, :students

    # issues
    remove_foreign_key :issues, :name => "fk_Issues_students"
    remove_column :issues, :students_Bnum
    add_column :issues, :student_id, :integer, :first => true, :null => false
    add_foreign_key :issues, :students

    # praxis_prep
    remove_foreign_key :praxis_prep, :name => "fk_PraxisPrep_Student"
    remove_column :praxis_prep, :Student_Bnum
    add_column :praxis_prep, :student_id, :integer, :first => true, :null => false
    add_foreign_key :praxis_prep, :students

    # praxis_result
    remove_foreign_key :praxis_results, :name => "fk_praxis_results_students"
    change_column :praxis_results, :student_id, :integer
    add_foreign_key :praxis_results, :students
    add_index :praxis_results, [:student_id, :praxis_test_id, :test_date],
        {unique: true, :name => "index_by_stu_test_date"}

    # prog_exits
    remove_foreign_key :prog_exits, :name => "fk_Exit_Student"
    remove_column :prog_exits, :Student_Bnum
    add_column :prog_exits, :student_id, :integer, :first => true, :null => false
    add_foreign_key :prog_exits, :students

    # student_files
    remove_foreign_key :student_files, :name => "fk_student_files_students"
    remove_column :student_files, :Student_Bnum
    add_column :student_files, :student_id, :integer, :first => true, :null => false
    add_foreign_key :student_files, :students

    # transcript
    remove_foreign_key :transcript, :name => "fk_transcript_students"
    remove_column :transcript, :Student_Bnum
    add_column :transcript, :student_id, :integer, :first => true, :null => false
    add_foreign_key :transcript, :students

  end

  def down
    remove_foreign_key :transcript, :students
    remove_column :transcript, :student_id
    add_column :transcript, :Student_Bnum, :string

    remove_foreign_key :student_files, :students
    remove_column :student_files, :student_id
    add_column :student_files, :Student_Bnum, :string

    remove_foreign_key :prog_exits, :students
    remove_column :prog_exits, :student_id
    add_column :prog_exits, :Student_Bnum, :string

    remove_foreign_key :praxis_results, :students
    change_column :praxis_results, :student_id, :string

    remove_foreign_key :praxis_prep, :students
    remove_column :praxis_prep, :student_id
    add_column :praxis_prep, :Student_Bnum, :string

    remove_foreign_key :issues, :students
    remove_column :issues, :student_id
    add_column :issues, :students_Bnum, :string

    remove_foreign_key :forms_of_intention, :students
    change_column :forms_of_intention, :student_id, :string

    remove_foreign_key :employment, :students
    remove_column :employment, :student_id
    add_column :employment, :Student_Bnum, :string

    remove_foreign_key :clinical_assignments, :students
    remove_column :clinical_assignments, :student_id
    add_column :clinical_assignments, :Bnum, :string

    remove_foreign_key :adm_tep, :students
    remove_column :adm_tep, :student_id
    add_column :adm_tep, :Student_Bnum, :string

    remove_foreign_key :adm_st, :students
    remove_column :adm_st, :student_id
    add_column :adm_st, :Student_Bnum, :string

    execute %q(ALTER TABLE `students`
    DROP PRIMARY KEY ,
    DROP COLUMN `id` ,
    DROP INDEX `Bnum_UNIQUE` ,
    ADD PRIMARY KEY (`Bnum`) ,
    ADD COLUMN `AltID` INT NOT NULL AUTO_INCREMENT AFTER `CPO` ,
    ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC);
    )

    #add old fks once everything is changed back
    add_foreign_key "clinical_assignments", "students", name: "fk_ClinicalAssignments_Student", column: "Bnum", primary_key: "Bnum"
    add_foreign_key "praxis_results", "students", name: "fk_praxis_results_students", primary_key: "Bnum"
    add_foreign_key "adm_tep", "students", name: "fk_AdmTEP_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "adm_st", "students", name: "fk_AdmST_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "prog_exits", "students", name: "fk_Exit_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "employment", "students", name: "fk_Employment_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "praxis_prep", "students", name: "fk_PraxisPrep_Student", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "student_files", "students", name: "fk_student_files_students", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "transcript", "students", name: "fk_transcript_students", column: "Student_Bnum", primary_key: "Bnum"
    add_foreign_key "issues", "students", name: "fk_Issues_students", column: "students_Bnum", primary_key: "Bnum"
    add_foreign_key :forms_of_intention, :students, primary_key: :Bnum

  end
end
