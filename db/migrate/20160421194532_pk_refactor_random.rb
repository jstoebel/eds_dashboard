    class PkRefactorRandom < ActiveRecord::Migration
  def up

    #need to drop fks referencing banner_terms first

    remove_foreign_key "transcript", name: "fk_transcript_banner_terms"
    remove_foreign_key "adm_tep", name: "fk_AdmTEP_BannerTerm"
    remove_foreign_key "adm_st", name: "fk_AdmST_BannerTerm"
    remove_foreign_key "prog_exits", name: "prog_exits_ExitTerm_fk"

    #MAKE banner_terms pk AI
    execute %q(ALTER TABLE `banner_terms` 
    CHANGE COLUMN `BannerTerm` `BannerTerm` INT(11) NOT NULL ;)

    #add fks back

    add_foreign_key "transcript", "banner_terms", name: "fk_transcript_banner_terms", column: "term_taken", primary_key: "BannerTerm"
    add_foreign_key "adm_tep", "banner_terms", name: "fk_AdmTEP_BannerTerm", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm"
    add_foreign_key "adm_st", "banner_terms", name: "fk_AdmST_BannerTerm", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm"
    add_foreign_key "prog_exits", :banner_terms, name: "prog_exits_ExitTerm_fk", column: "ExitTerm", primary_key: "BannerTerm"

  end

  def down

    #new lines below this line
    remove_foreign_key "transcript", name: "fk_transcript_banner_terms"
    remove_foreign_key "adm_tep", name: "fk_AdmTEP_BannerTerm"
    remove_foreign_key "adm_st", name: "fk_AdmST_BannerTerm"
    remove_foreign_key "prog_exits", name: "prog_exits_ExitTerm_fk"


    execute %q(ALTER TABLE `banner_terms` 
    CHANGE COLUMN `BannerTerm` `BannerTerm` INT(11) NOT NULL AUTO_INCREMENT ;)

    add_foreign_key "transcript", "banner_terms", name: "fk_transcript_banner_terms", column: "term_taken", primary_key: "BannerTerm"
    add_foreign_key "adm_tep", "banner_terms", name: "fk_AdmTEP_BannerTerm", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm"
    add_foreign_key "adm_st", "banner_terms", name: "fk_AdmST_BannerTerm", column: "BannerTerm_BannerTerm", primary_key: "BannerTerm"
    add_foreign_key "prog_exits", :banner_terms, name: "prog_exits_ExitTerm_fk", column: "ExitTerm", primary_key: "BannerTerm"
    
  end
end