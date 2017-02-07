class AddActive < ActiveRecord::Migration
  def up
    add_column :downtimes, :active, :boolean
  end

  def down
    remove_column :downtimes, :active
  end
end
