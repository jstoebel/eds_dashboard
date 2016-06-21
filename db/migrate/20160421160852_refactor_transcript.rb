class RefactorTranscript < ActiveRecord::Migration
  def up
    execute %q(ALTER TABLE `transcript` 
    DROP PRIMARY KEY;)
    
    add_column :transcript, :id, :primary_key, :first => true
    add_index :transcript, [:crn, :student_id]

  end

  def down

    remove_foreign_key :transcript, :name => "fk_transcript_banner_terms"
    remove_foreign_key :transcript, :name => "transcript_student_id_fk"

    remove_index :transcript, :name => "index_transcript_on_crn_and_student_id"
    remove_column :transcript, :id

    execute %q(ALTER TABLE `transcript` 
    ADD PRIMARY KEY (`crn`);)

    add_foreign_key :transcript, :banner_terms, name: "fk_transcript_banner_terms", column: "term_taken", primary_key: "BannerTerm"
    add_foreign_key :transcript, :students, name: "transcript_student_id_fk" 

  end
end
