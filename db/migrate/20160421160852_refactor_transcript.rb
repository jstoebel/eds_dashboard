class RefactorTranscript < ActiveRecord::Migration
  def up
    execute %q(ALTER TABLE `transcript` 
    DROP PRIMARY KEY;)
    
    add_column :transcript, :id, :primary_key, :first => true
    add_index :transcript, [:crn, :student_id]

  end

  def down

    remove_index :transcript, :name => "index_transcript_on_crn_and_student_id"
    remove_column :transcript, :id

    execute %q(ALTER TABLE `transcript` 
    ADD PRIMARY KEY (`crn`);)

  end
end
