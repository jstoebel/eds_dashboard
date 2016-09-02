class ChangeCutScore < ActiveRecord::Migration
  def up
    remove_column :praxis_results, :cut_score
  end

  def down
    add_column :praxis_results, :cut_score, :integer, limit: 4
  end
end
