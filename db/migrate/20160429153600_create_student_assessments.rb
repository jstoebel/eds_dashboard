class CreateStudentAssessments < ActiveRecord::Migration
  def up
    create_table :student_assessments do |t|
      t.integer :student_id, :null => false
      t.integer :assessment_version_id, :null => false
      t.timestamps
    end
    add_foreign_key :student_assessments, :students
    add_foreign_key :student_assessments, :assessment_versions
  end

  def down
    drop_table :student_assessments
  end
end
