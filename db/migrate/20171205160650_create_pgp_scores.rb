class CreatePgpScores < ActiveRecord::Migration[5.0]
  def up
    create_table :pgp_scores do |t|
      t.references :pgp_goal
      t.timestamps
    end

    add_foreign_key :pgp_scores, :pgp_goals

    change_table :student_scores do |t|
      t.actable
    end
  end

  def down
    change_table :student_scores do |t|
      t.remove :actable_id
      t.remove  :actable_type
    end
    remove_foreign_key :pgp_scores, :pgp_goals
    drop_table :pgp_scores

  end
end
