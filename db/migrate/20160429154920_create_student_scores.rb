class CreateStudentScores < ActiveRecord::Migration
  def up
    create_table :student_scores do |t|
      t.integer :student_id, :null => false
      t.integer :assessment_version_id, :null => false
      t.integer :assessment_item_id, :null => false
      t.integer :item_level_id, :null => false
      t.timestamps
    end
  end
  
  def down
    drop_table :student_scores
  end
  
end
