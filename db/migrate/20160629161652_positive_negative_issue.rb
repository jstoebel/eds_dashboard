class PositiveNegativeIssue < ActiveRecord::Migration
  def up
    add_column :issues, :positive, :bool
  end

  def down
    remove_column :issues, :positive
  end
end
