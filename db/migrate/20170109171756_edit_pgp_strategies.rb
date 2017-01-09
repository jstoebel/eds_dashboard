class EditPgpStrategies < ActiveRecord::Migration
  def up
    add_column :pgps, :strategies, :text
  end

  def  down
    remove_column :pgps, :strategies
  end
end
