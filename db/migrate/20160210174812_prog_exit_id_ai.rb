class ProgExitIdAi < ActiveRecord::Migration
  def up
    execute %q(ALTER TABLE `prog_exits` 
CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT;)
  end

  def down
    execute %q(ALTER TABLE `prog_exits` 
CHANGE COLUMN `id` `id` INT(11) NOT NULL ;)
  end
end
