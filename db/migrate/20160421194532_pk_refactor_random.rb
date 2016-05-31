class PkRefactorRandom < ActiveRecord::Migration
  def up

    #MAKE banner_terms pk AI
    execute %q(ALTER TABLE `banner_terms` 
    CHANGE COLUMN `BannerTerm` `BannerTerm` INT(11) NOT NULL ;)


    #FK clinical_assignment -> banner_term
    #new lines above this line ^

  end

  def down

    #new lines below this line

    execute %q(ALTER TABLE `banner_terms` 
    CHANGE COLUMN `BannerTerm` `BannerTerm` INT(11) NOT NULL AUTO_INCREMENT ;)
  end
end