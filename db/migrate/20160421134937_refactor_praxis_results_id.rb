class RefactorPraxisResultsId < ActiveRecord::Migration
  def up

    change_table :praxis_results do |t|
        t.remove :id
        t.remove :AltID
    end

    add_column :praxis_results, :id, :primary_key, :first => true
    #also add a fk for sub_tests
    change_column :praxis_subtest_results, :praxis_result_id, :integer
    add_foreign_key :praxis_subtest_results, :praxis_results
    
  end

  def down
    remove_foreign_key :praxis_subtest_results, :praxis_results
    change_column :praxis_subtest_results, :praxis_result_id, :string

    remove_column :praxis_results, :id

    execute %q(ALTER TABLE `praxis_results` 
    ADD COLUMN `id` VARCHAR(45) NULL FIRST,
    ADD COLUMN `AltID` INT NULL AUTO_INCREMENT AFTER `pass`,
    ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC); )
  end
end
