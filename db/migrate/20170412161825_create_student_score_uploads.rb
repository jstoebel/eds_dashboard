class CreateStudentScoreUploads < ActiveRecord::Migration
  def up
    create_table :student_score_uploads do |t|

      t.string :source # qualtrics, moodle, etc
      t.boolean :success
      t.text :message
      t.timestamps null: false
    end

    [:student_scores, :student_score_temps].each do |tbl|
      add_column tbl, :student_score_upload_id, :integer
      add_foreign_key tbl, :student_score_uploads
    end
  end

  def down
    [:student_scores, :student_score_temps].each do |tbl|
      remove_foreign_key tbl, :student_score_uploads
      remove_column tbl, :student_score_upload_id
    end

    drop_table :student_score_uploads

  end
end
