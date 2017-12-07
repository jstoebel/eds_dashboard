class ItemLevelLevel < ActiveRecord::Migration[5.0]
  def up
    change_column :item_levels, :level, :integer
  end

  def down
    change_column :item_levels, :level, :string
  end
end
