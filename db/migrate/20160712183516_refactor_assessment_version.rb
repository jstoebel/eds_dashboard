class RefactorAssessmentVersion < ActiveRecord::Migration
  def up
    remove_column :assessment_versions, :version_num
  end
  
  def down
    add_column :assessment_versions, :version_num, :integer
  end
end
