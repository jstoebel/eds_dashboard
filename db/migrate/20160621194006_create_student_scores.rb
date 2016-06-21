class CreateStudentScores < ActiveRecord::Migration
  def change
    create_table :student_scores do |t|

      t.timestamps
    end
  end
end
