class AddItemLevelOrd < ActiveRecord::Migration
  def up

    change_table :item_levels do |t|
        t.change :level, :string
        t.integer :ord, :after => :level
    end
  end

  def down

    change_table :item_levels do |t|
        t.change :level, :integer
        t.remove :ord
    end
  end
end
