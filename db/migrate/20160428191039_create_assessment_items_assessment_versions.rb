class CreateAssessmentItemsAssessmentVersions < ActiveRecord::Migration
  def up
    create_table :assessment_items_assessment_versions do |t|
      t.integer :assessment_version_id
      t.integer :assessment_item_id
      t.string :item_code  #the item's code (example 3A or B-2)
      t.timestamps
    end

    add_foreign_key :assessment_items_assessment_versions, :assessment_versions
    add_foreign_key :assessment_items_assessment_versions, :assessment_items
  end

  def down
    drop_table :assessment_items_assessment_versions
  end
end
