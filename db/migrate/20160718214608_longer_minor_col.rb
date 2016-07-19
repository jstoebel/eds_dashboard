class LongerMinorCol < ActiveRecord::Migration
  def up
    change_column :students, :CurrentMinors, :string, :limit => 255
  end

  def down
    change_column :students, :CurrentMinors, :string, :limit => 45    
  end
end
