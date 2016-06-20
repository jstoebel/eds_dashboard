class DropAssessmentItemVersions < ActiveRecord::Migration
  def up
    drop_table :assessment_item_versions
  end
  
  def down
    create_table :assessment_item_versions do |t|
      t.integer :assessment_version_id, :null => false
      t.integer :assessment_item_id, :null => false
      t.string :item_code  #the item's code (example 3A or B-2)
      t.timestamps
    end

    add_foreign_key :assessment_item_versions, :assessment_versions
    add_foreign_key :assessment_item_versions, :assessment_items
  end
end
