class AdvisorAssignments < ActiveRecord::Migration
  def up

  	change_table :advisor_assignments do |t|
  		t.rename :students_Bnum, :Student_Bnum
  	end

  	#also add composite pk
  	execute %q(ALTER TABLE `advisor_assignments`
  			ADD PRIMARY KEY (`tep_advisors_AdvisorBnum`, `students_Bnum`);)
  end

  def down
  	execute %q(ALTER TABLE `advisor_assignments` 
		DROP PRIMARY KEY;)

  	change_table :advisor_assignments do |t|
  		t.rename :Student_Bnum, :students_Bnum 
  	end

  end

end
