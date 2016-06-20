class DropAssessmentScores < ActiveRecord::Migration
  def up
   drop_table :assessment_scores
  end

  def down
    create_table :assessment_scores do |t|
      t.integer :student_assessment_id, :null => false
      t.integer :assessment_item_version_id, :null => false
      t.integer :score
      t.timestamps
    end

    add_foreign_key :assessment_scores, :student_assessments
    add_foreign_key :assessment_scores, :assessment_item_versions
  end
end