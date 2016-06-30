class PgpScores < ActiveRecord::Migration
  def up
    create_table :pgp_scores do |t|
      t.integer :pgp_id
      t.integer :goal_score
      t.text :score_reason
      t.timestamps :score_date
    end
    add_foreign_key(:pgp_scores, :pgps)
  end
  
  def down
    remove_foreign_key(:pgp_scores, :pgps)
    drop_table :pgp_scores
  end
end
