class VersionHabtmItems < ActiveRecord::Migration
  def up
    create_table :version_habtm_items do |t|
      t.integer :assessment_version_id, :null => false
      t.integer :assessment_item_id, :null => false
      t.timestamps
    end
    
    add_foreign_key :version_habtm_items, :assessment_versions
    add_foreign_key :version_habtm_items, :assessment_items
    
  end
  
  def down
    drop_table :version_habtm_items
  end
end
