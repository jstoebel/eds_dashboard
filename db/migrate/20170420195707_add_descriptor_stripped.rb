class AddDescriptorStripped < ActiveRecord::Migration[5.0]
  def up
    add_column :item_levels, :descriptor_stripped, :text

    # add indexies for descriptor and descriptor_stripped
    [:descriptor, :descriptor_stripped].each {|col| add_index :item_levels, col}

  end

  def down
    [:descriptor, :descriptor_stripped].each {|col| remove_index :item_levels, col}
    remove_column :item_levels, :descriptor_stripped, :text
  end
end
