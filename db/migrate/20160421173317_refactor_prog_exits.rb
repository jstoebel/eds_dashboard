class RefactorProgExits < ActiveRecord::Migration
  def up
    execute %q(ALTER TABLE `prog_exits`
        DROP PRIMARY KEY ;)
    
    remove_column :prog_exits, :AltID
    add_column :prog_exits, :id, :primary_key, :first => true
    add_foreign_key :prog_exits, :banner_terms, :column => :ExitTerm, :primary_key => :BannerTerm
    add_index :prog_exits, [:student_id, :Program_ProgCode]

  end

  def down

    remove_foreign_key :prog_exits, :name => "prog_exits_student_id_fk"
    remove_foreign_key :prog_exits, :name => "prog_exits_Program_ProgCode_fk"
    remove_index :prog_exits, :name => "index_prog_exits_on_student_id_and_Program_ProgCode"
    remove_foreign_key :prog_exits, :name => "prog_exits_ExitTerm_fk"
    remove_column :prog_exits, :id

    execute %q(ALTER TABLE `prog_exits` 
    ADD COLUMN `AltID` INT NULL AUTO_INCREMENT AFTER `Details`,
    ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC) ,
    ADD PRIMARY KEY (`Program_ProgCode`); )

    add_foreign_key :prog_exits, :students
    add_foreign_key :prog_exits, :programs, :column => :Program_ProgCode

  end
end
