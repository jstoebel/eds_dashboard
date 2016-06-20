class DropStudentAssessments < ActiveRecord::Migration
  def up
   drop_table :student_assessments
  end
   
  def down
    create_table :student_assessments do |t|
      t.integer :student_id, :null => false
      t.integer :assessment_version_id, :null => false
      t.timestamps
    end
    add_foreign_key :student_assessments, :students
    add_foreign_key :student_assessments, :assessment_versions
  end
end
