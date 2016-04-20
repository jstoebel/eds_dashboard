class RefactorTepAdvisor < ActiveRecord::Migration
  def up


    #remove tep_advisors pk
    execute %q(ALTER TABLE `tep_advisors` 
    DROP PRIMARY KEY;
    )

    change_table :tep_advisors do |t|
        t.integer :id, :primary_key, :first => true
        t.remove :AdvisorBnum
    end

    #remove fks pointing to tep_advisors
    #add change data types
    # add new fks

    #advisor_assignments
    remove_foreign_key :advisor_assignments, :name => "advisor_assignments_tep_advisors_AdvisorBnum_fk"
    
    execute %q(ALTER TABLE `advisor_assignments` 
    DROP PRIMARY KEY;
    )

    change_table  :advisor_assignments do |t|
        t.remove  :tep_advisors_AdvisorBnum
        t.integer :tep_advisor_id
    end

    add_foreign_key :advisor_assignments, :tep_advisors


  end

  def down

    execute %q(ALTER TABLE `tep_advisors` 
    DROP PRIMARY KEY;
    )

    change_table :tep_advisors do |t|
        t.remove :id
        t.string :AdvisorBnum, :primary_key, :first => true
    end

  end
end
