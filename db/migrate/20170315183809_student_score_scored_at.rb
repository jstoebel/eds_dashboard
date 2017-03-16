class StudentScoreScoredAt < ActiveRecord::Migration
  def up
    add_column :student_scores, :scored_at, :datetime, :after => :item_level_id
  end

  def down
    remove_column :student_scores, :scored_at
  end
end
