class CreateAssessmentVersions < ActiveRecord::Migration
  def up
    create_table :assessment_versions do |t|
      t.integer :assessment_id, :null => false
      t.integer :version_num
      t.timestamps
    end
    
    add_foreign_key :assessment_versions, :assessments
  end

  def down
    drop_table :assessment_versions
  end
end
