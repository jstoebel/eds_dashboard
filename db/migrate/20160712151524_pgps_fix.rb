class PgpsFix < ActiveRecord::Migration
  def up
    change_table :pgps do |t|
      t.remove :goal_score
      t.remove :score_reason
    end
  end
  
  def down
    change_table :pgps do |t|
      t.integer :goal_score
      t.text :score_reason
    end
  end
  
end
