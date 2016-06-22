class StudentScoreFk < ActiveRecord::Migration
  def up
    add_foreign_key :student_scores, :students
    add_foreign_key :student_scores, :assessment_versions
    add_foreign_key :student_scores, :item_levels
    add_foreign_key :student_scores, :assessment_items
  end
  
  def down
    remove_foreign_key :student_scores, :students
    remove_foreign_key :student_scores, :assessment_versions
    remove_foreign_key :student_scores, :item_levels
    remove_foreign_key :student_scores, :assessment_items
  end
end
