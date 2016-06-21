class RefactorExitCodes < ActiveRecord::Migration
  def up
    
    #remove fk prog_exits -> exit_codes
    remove_foreign_key :prog_exits, :name => "fk_Exit_ExitCode"

    #add id as pk
    execute %q(ALTER TABLE `exit_codes` 
    DROP PRIMARY KEY;)

    add_column :exit_codes, :id, :primary_key, :first => true
    change_column :exit_codes, :ExitCode, :string, :null => false, :limit => 5
    
    #create new fk prog_exits -> exit_codes 

    change_column :prog_exits, :ExitCode_ExitCode, :integer, :unique => true
    add_foreign_key :prog_exits, :exit_codes, :column => "ExitCode_ExitCode"

  end

  def down

    # remove_foreign_key :prog_exits, :name => "prog_exits_ExitCode_ExitCode_fk"
    # change_column :prog_exits, :ExitCode_ExitCode, :string
    change_column :exit_codes, :ExitCode, :string, :null => true
    remove_column :exit_codes, :id
    execute %q(ALTER TABLE `exit_codes` 
    ADD PRIMARY KEY (`ExitCode`);)

    add_foreign_key "prog_exits", "exit_codes", name: "fk_Exit_ExitCode", column: "ExitCode_ExitCode", primary_key: "ExitCode"

  end
end
