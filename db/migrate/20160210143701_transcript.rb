class Transcript < ActiveRecord::Migration
  def up

  	#rename B# column
  	change_table :transcript do |t|
        t.rename :students_Bnum, :Student_Bnum
  	end

    #also add student bnum as part of PK
    execute %q(ALTER TABLE `transcript` 
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (`crn`, `Student_Bnum`);)

  end

  def down
    execute %q(ALTER TABLE `transcript` 
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (`crn`);)

    change_table :transcript do |t|
        t.rename :Student_Bnum, :students_Bnum
    end

  end
end
