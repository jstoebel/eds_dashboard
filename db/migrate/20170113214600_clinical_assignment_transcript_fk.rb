class ClinicalAssignmentTranscriptFk < ActiveRecord::Migration
  def up
    # remove CourseID
    change_table(:clinical_assignments) do |t|
      t.remove :CourseID
      t.integer :transcript_id
    end
    add_foreign_key :clinical_assignments, :transcript
    # relate to transcript
  end

  def down
    remove_foreign_key :clinical_assignments, :transcript
    change_table(:clinical_assignments) do |t|
      t.remove :transcript_id
      t.string  "CourseID", limit: 45, null: false
    end
    # remove transcript_id
    # add CourseID
  end
end
