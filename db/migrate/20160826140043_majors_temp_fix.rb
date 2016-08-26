class MajorsTempFix < ActiveRecord::Migration
  def up
    change_table :majors do |t|
      add_foreign_key :temp_foi, :majors 
    end
  end
  
  def down
    remove_foreign_key :temp_foi, :majors
  end
end
