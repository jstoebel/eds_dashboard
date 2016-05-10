class TranscriptIndex < ActiveRecord::Migration
  def up
    remove_index :transcript, :name => "index_transcript_on_crn_and_student_id"
    add_index :transcript, [:student_id, :crn, :term_taken], :unique => true
  end

  def down
    remove_index :transcript, :name => "index_transcript_on_student_id_and_crn_and_term_taken"
    add_index :transcript, [:student_id, :crn], :name => "index_transcript_on_crn_and_student_id"

  end
end
