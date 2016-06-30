class CreatePgps < ActiveRecord::Migration
  def up
    create_table :pgps do |t|
      t.integer :student_id
      t.string :goal_name
      t.text :description
      t.text :plan
      t.timestamps :created_at
    end
    add_foreign_key(:pgps, :students)
    
  end
  
  def down
    remove_foreign_key(:pgps, :students)
    drop_table :pgps 
  end
  
end
