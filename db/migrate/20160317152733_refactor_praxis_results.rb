class RefactorPraxisResults < ActiveRecord::Migration
  def up

    drop_table :praxis_results
    create_table    :praxis_results do |t|
        t.string    :student_id
        t.string    :praxis_test_id
        t.datetime  :test_date
        t.datetime  :reg_date
        t.string    :paid_by
        t.integer   :test_score
        t.integer   :best_score
        t.integer   :cut_score
        t.boolean    :pass 
    end

    # remove ai from pk and add ai column AltID
    execute %q(ALTER TABLE `praxis_results` 
      CHANGE COLUMN `id` `id` INT(11) NOT NULL ,
      ADD COLUMN `AltID` INT NULL AUTO_INCREMENT AFTER `pass`,
      ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC);)

    #add fks to students and praxis_tests
    execute %q(ALTER TABLE `praxis_results` 
      ADD INDEX `fk_praxis_results_students_idx` (`student_id` ASC),
      ADD INDEX `fk_praxis_results_praxis_tests_idx` (`praxis_test_id` ASC))
    
    execute %q(ALTER TABLE `praxis_results` 
      ADD CONSTRAINT `fk_praxis_results_students`
        FOREIGN KEY (`student_id`)
        REFERENCES `students` (`Bnum`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
      ADD CONSTRAINT `fk_praxis_results_praxis_tests`
        FOREIGN KEY (`praxis_test_id`)
        REFERENCES `praxis_tests` (`TestCode`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION)
  end

  def down

    drop_table :praxis_results
    create_table "praxis_results", primary_key: "TestID", force: true do |t|
      t.string   "Bnum",      limit: 9,  null: false
      t.string   "TestCode",  limit: 45, null: false
      t.datetime "TestDate"
      t.datetime "RegDate"
      t.string   "PaidBy",    limit: 45
      t.integer  "TestScore"
      t.integer  "BestScore"
      t.integer  "CutScore"
      t.boolean  "Pass"
      t.integer  "AltID",                null: false
    end

      add_index "praxis_results", ["AltID"], name: "AltID_UNIQUE", unique: true, using: :btree
      add_index "praxis_results", ["Bnum"], name: "fk_PraxisResult_Student1_idx", using: :btree
      add_index "praxis_results", ["TestCode"], name: "fk_PraxisResult_PraxisTest1_idx", using: :btree

  end
end
