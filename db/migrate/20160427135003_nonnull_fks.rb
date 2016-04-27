class NonnullFks < ActiveRecord::Migration
  def up
    change_column :adm_tep, :student_id, :integer, :null => false
    change_column :praxis_results, :student_id, :integer, :null => false
    change_column :praxis_subtest_results, :praxis_result_id, :integer, :null => false
    change_column :tep_advisors, :user_id, :integer, :null => false

  end

  def down

    change_column :adm_tep, :student_id, :integer, :null => true
    change_column :praxis_results, :student_id, :integer, :null => true
    change_column :praxis_subtest_results, :praxis_result_id, :integer, :null => true
    change_column :tep_advisors, :user_id, :integer, :null => true


  end
end
