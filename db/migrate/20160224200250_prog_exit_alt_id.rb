class ProgExitAltId < ActiveRecord::Migration
  def up
    execute %q(ALTER TABLE `prog_exits` 
    ADD COLUMN `AltID` INT NULL AUTO_INCREMENT AFTER `Details`,
    ADD UNIQUE INDEX `AltID_UNIQUE` (`AltID` ASC);
    )
  end

  def down 
    execute %q(ALTER TABLE `prog_exits` 
  DROP COLUMN `AltID`;)

  end
end
