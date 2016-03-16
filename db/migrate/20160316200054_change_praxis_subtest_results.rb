class ChangePraxisSubtestResults < ActiveRecord::Migration
  def up
    drop_table :praxis_subtest_results

    create_table :praxis_subtest_results do |t|
        t.string :praxis_result_id
        t.integer :sub_number
        t.string :name
        t.integer :pts_earned
        t.integer :pts_aval
        t.integer :avg_high
        t.integer :avg_low
    end
  end

  def down

    drop_table :praxis_subtest_results

    create_table "praxis_subtest_results", primary_key: "SubTestID", force: true do |t|
        t.string  "SubNumber",             limit: 45, null: false
        t.string  "praxis_results_TestID", limit: 45, null: false
        t.string  "Name",                  limit: 45
        t.integer "PtsEarned"
        t.integer "PtsAval"
        t.integer "AvgHigh"
        t.integer "AvgLow"
    end

    add_index "praxis_subtest_results", ["praxis_results_TestID"], name: "fk_praxis_subtest_results_praxis_results1_idx", using: :btree

  end
end
