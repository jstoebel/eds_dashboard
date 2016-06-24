class AdvisorsMayHaveNoUser < ActiveRecord::Migration
  def up
    change_column :tep_advisors, :user_id, :integer, :null => true
  end

  def down
    change_column :tep_advisors, :user_id, :integer, :null => false
  end
end
