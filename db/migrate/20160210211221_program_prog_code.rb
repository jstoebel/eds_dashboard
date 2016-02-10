class ProgramProgCode < ActiveRecord::Migration
  def up
   execute %q(ALTER TABLE `programs` 
CHANGE COLUMN `ProgCode` `ProgCode` VARCHAR(10) NOT NULL;)
  end

  def down
    execute %q(ALTER TABLE `programs` 
CHANGE COLUMN `ProgCode` `ProgCode` INT(11) NOT NULL AUTO_INCREMENT ;)
  end
end
