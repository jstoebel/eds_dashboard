class ItemLevelsPassingScore < ActiveRecord::Migration
  def up
    change_table :item_levels do |t|
      t.boolean :passing
      t.remove :cut_score
    end
  end

  def down

    change_table :item_levels do |t|
      t.boolean :cut_score
      t.remove :passing
    end
  end
  
end
