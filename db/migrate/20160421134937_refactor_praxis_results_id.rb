class RefactorPraxisResultsId < ActiveRecord::Migration
  def up

    change_column :praxis_results, :id, :integer

    #also add a fk for sub_tests
    change_column :praxis_subtest_results, :praxis_result_id, :integer
    add_foreign_key :praxis_subtest_results, :praxis_results
    
  end

  def down
    remove_foreign_key :praxis_subtest_results, :praxis_results
    change_column :praxis_subtest_results, :praxis_result_id, :string
    change_column :praxis_results, :id, :string
  end
end
