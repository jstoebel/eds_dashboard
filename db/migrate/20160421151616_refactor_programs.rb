class RefactorPrograms < ActiveRecord::Migration
  def up

    #remove fks, change column data type
    remove_foreign_key :praxis_tests, :name => "fk_PraxisTest_Program"
    change_column :praxis_tests, :Program_ProgCode, :integer, :null => false

    remove_foreign_key :prog_exits, :name => "fk_Exit__Program"
    change_column :prog_exits, :Program_ProgCode, :integer, :null => false

    change_column :adm_tep, :Program_ProgCode, :integer, :null => false

    #drop pk and add new one
    execute %q(ALTER TABLE `programs` 
    ADD UNIQUE INDEX `ProgCode_UNIQUE` (`ProgCode` ASC) ,
    DROP PRIMARY KEY ;)

    add_column :programs, :id, :primary_key, :first => true

    #hook up to new pk
    add_foreign_key :praxis_tests, :programs, :column => :Program_ProgCode
    add_foreign_key :prog_exits, :programs, :column => :Program_ProgCode
    add_foreign_key :adm_tep, :programs, :column => :Program_ProgCode

  end

  def down

    remove_foreign_key :praxis_tests, :column => :Program_ProgCode
    remove_foreign_key :prog_exits, :column => :Program_ProgCode
    remove_foreign_key :adm_tep, :column => :Program_ProgCode

    remove_column :programs, :id

    execute %q(ALTER TABLE `programs` 
    DROP INDEX `ProgCode_UNIQUE` ,
    ADD PRIMARY KEY(`ProgCode`) ;)

    change_column :adm_tep, :Program_ProgCode, :string

    change_column :prog_exits, :Program_ProgCode, :string
    add_foreign_key "prog_exits", "programs", name: "fk_Exit__Program", column: "Program_ProgCode", primary_key: "ProgCode"

    change_column :praxis_tests, :Program_ProgCode, :string
    add_foreign_key "praxis_tests", "programs", name: "fk_PraxisTest_Program", column: "Program_ProgCode", primary_key: "ProgCode"

  end

end
