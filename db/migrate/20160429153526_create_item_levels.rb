class CreateItemLevels < ActiveRecord::Migration
  def up
    create_table :item_levels do |t|
      t.integer :assessment_item_id, :null => false
      t.text :descriptor
      t.integer :level
      t.timestamps
    end

    add_foreign_key :item_levels, :assessment_items
  end

  def down
    drop_table :item_levels  
  end
end
