class RefactorTepAdvisor < ActiveRecord::Migration
  def up

    execute %q(ALTER TABLE `tep_advisors` 
    DROP PRIMARY KEY;)

    add_column :tep_advisors, :id, :primary_key, :first => true

    remove_foreign_key :advisor_assignments, :name=> "fk_students_has_tep_advisors_tep_advisors"
    remove_foreign_key :advisor_assignments, :name=> "fk_students_has_tep_advisors_students"

    drop_table :advisor_assignments

    create_table :advisor_assignments do |t|
        t.integer :student_id, null: false
        t.integer :tep_advisor_id, null: false
    end

    add_foreign_key :advisor_assignments, :tep_advisors
    add_foreign_key :advisor_assignments, :students

    add_index :advisor_assignments, [:student_id, :tep_advisor_id],
        unique: true

  end

  def down
    drop_table :advisor_assignments

    create_table "advisor_assignments", id: false, force: true do |t|
        t.string "students_Bnum",            limit: 9, null: false
        t.string "tep_advisors_AdvisorBnum", limit: 9, null: false
    end

    add_foreign_key "advisor_assignments", "tep_advisors", name: "fk_students_has_tep_advisors_students", column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"
    add_foreign_key "advisor_assignments", "tep_advisors", name: "fk_students_has_tep_advisors_tep_advisors",  column: "tep_advisors_AdvisorBnum", primary_key: "AdvisorBnum"
    
    remove_column :tep_advisors, :id

    execute %q(ALTER TABLE `tep_advisors` 
    ADD PRIMARY KEY (`AdvisorBnum`);)

  end
end
