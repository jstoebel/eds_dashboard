class AssessmentItemsOrd < ActiveRecord::Migration[5.0]
  def up
    add_column :assessment_items, :ord, :integer
  end

  def down
    remove_column :assessment_items, :ord
  end
end
