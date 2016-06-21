class CreatePgps < ActiveRecord::Migration
  def up
    
    create_table :pgps do |t|
      t.integer :pgp_id
      t.string :goal_name
      t.text :description
      t.text :plan
      t.timestamps
    end
    add_foreign_key(:goal_name, :description, :plan)
  end
  
  def down
    remove_foreign_key(:goal_name, :description, :plan)
    drop_table :pgps 
  end
  
end
