class RefactorPraxis < ActiveRecord::Migration
  def up
    # refactor for praxis_results and praxis_tests

    remove_foreign_key :praxis_results, :name => "fk_praxis_results_praxis_tests"
    remove_foreign_key :praxis_prep, :name => "fk_PraxisPrep_PraxisTest"

    execute %q(ALTER TABLE `praxis_tests` 
    DROP PRIMARY KEY ,
    ADD UNIQUE INDEX `TestCode_UNIQUE` (`TestCode` ASC);)

    add_column :praxis_tests, :id, :primary_key, :first => true

    change_column :praxis_results, :praxis_test_id, :integer
    add_foreign_key :praxis_results, :praxis_tests

    change_column :praxis_prep, :PraxisTest_TestCode, :integer
    add_foreign_key :praxis_prep, :praxis_tests, :column => "PraxisTest_TestCode"

  end

  def down

    remove_foreign_key :praxis_prep, :name => "praxis_prep_PraxisTest_TestCode_fk"
    change_column :praxis_prep, :PraxisTest_TestCode, :string

    remove_foreign_key :praxis_results, :name => "praxis_results_praxis_test_id_fk"
    change_column :praxis_results, :praxis_test_id, :string

    execute %q(ALTER TABLE `praxis_tests` 
    DROP PRIMARY KEY ,
    DROP COLUMN `id` ,
    DROP INDEX `TestCode_UNIQUE` ,
    ADD PRIMARY KEY (`TestCode`);)

    add_foreign_key "praxis_prep", "praxis_tests", name: "fk_PraxisPrep_PraxisTest", column: "PraxisTest_TestCode", primary_key: "TestCode"
    add_foreign_key :praxis_results, :praxis_tests, :primary_key => "TestCode", :name => "fk_praxis_results_praxis_tests"

    
  end
end
