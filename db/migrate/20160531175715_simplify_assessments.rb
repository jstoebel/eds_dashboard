class SimplifyAssessments < ActiveRecord::Migration
  def up

    remove_foreign_key :assessment_item_versions, :name => "assessment_item_versions_assessment_item_id_fk"
    remove_foreign_key :assessment_item_versions, :name => "assessment_item_versions_assessment_version_id_fk"
    remove_foreign_key :assessment_scores, :name => "assessment_scores_assessment_item_version_id_fk"
    remove_foreign_key :assessment_scores, :name => "assessment_scores_student_assessment_id_fk"
    remove_foreign_key :student_assessments, :name => "student_assessments_assessment_version_id_fk"
    remove_foreign_key :student_assessments, :name => "student_assessments_student_id_fk"
    
    drop_table :assessment_item_versions
    drop_table :assessment_scores
    drop_table :student_assessments

    create_table :student_scores do |t|
        t.integer :student_id
        t.integer :assessment_version_id
        t.integer :item_level_id
        t.integer :assessment_item_id
    end

    add_foreign_key :student_scores, :students
    add_foreign_key :student_scores, :assessment_versions
    add_foreign_key :student_scores, :item_levels
    add_foreign_key :student_scores, :assessment_items    
  end

  def down

    remove_foreign_key :student_scores, :assessment_items
    remove_foreign_key :student_scores, :item_levels
    remove_foreign_key :student_scores, :assessment_versions
    remove_foreign_key :student_scores, :students

    drop_table :student_scores


    #replace student_assessments
    create_table :student_assessments do |t|
      t.integer :student_id, :null => false
      t.integer :assessment_version_id, :null => false
      t.timestamps
    end


    #replace assessment_scores
    create_table :assessment_scores do |t|
      t.integer :student_assessment_id, :null => false
      t.integer :assessment_item_version_id, :null => false
      t.integer :score
      t.timestamps
    end

    #replace assessment_item_versions
    create_table :assessment_item_versions do |t|
      t.integer :assessment_version_id, :null => false
      t.integer :assessment_item_id, :null => false
      t.string :item_code  #the item's code (example 3A or B-2)
      t.timestamps
    end

    add_foreign_key :student_assessments, :students
    add_foreign_key :student_assessments, :assessment_versions

    add_foreign_key :assessment_scores, :student_assessments
    add_foreign_key :assessment_scores, :assessment_item_versions

    add_foreign_key :assessment_item_versions, :assessment_versions
    add_foreign_key :assessment_item_versions, :assessment_items

  end
end
