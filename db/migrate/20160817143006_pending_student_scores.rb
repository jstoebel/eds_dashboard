class PendingStudentScores < ActiveRecord::Migration
  def up
    create_table :pending_student_scores do |t|
      t.integer :assessment_version_id, :null => false
      t.integer :assessment_item_id, :null => false
      t.integer :item_level_id, :null => false
      t.timestamps
    end
    
    #add_foreign_key :pending_student_scores, :students
  end

  def down
    drop_table :pending_student_scores
  end
end