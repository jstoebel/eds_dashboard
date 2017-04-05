class CreateStudentScoreTemps < ActiveRecord::Migration
  def up
    create_table :student_score_temps do |t|

      t.integer :student_id, null: true
      t.integer :item_level_id, null: true
      t.datetime :scored_at, null: true
      t.string :full_name
      t.timestamps
    end
  end

  def down
    drop_table :student_score_temps  end
end
