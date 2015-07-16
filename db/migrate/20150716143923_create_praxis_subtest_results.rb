class CreatePraxisSubtestResults < ActiveRecord::Migration
  def change
    create_table :praxis_subtest_results do |t|

      t.timestamps
    end
  end
end
