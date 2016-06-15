class EditIssue < ActiveRecord::Migration
  
  def up
    change_table :issues do |t|
        t.boolean :visible, :null => false, default: true
    end
  end
  
  def down
    change_table :issues do |t|
      t.remove :visible
    end
  end
  
end
