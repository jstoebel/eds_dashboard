class AlterBannerUpdate < ActiveRecord::Migration
  def up
	change_table :banner_updates do |t|
		t.remove :upload_date
		t.integer :start_term
		t.integer :end_term
	end
	add_foreign_key :banner_updates, :banner_terms, :column => :start_term, :primary_key => :BannerTerm
	add_foreign_key :banner_updates, :banner_terms, :column => :end_term, :primary_key => :BannerTerm

  end

  def down
  	remove_foreign_key :banner_updates, :column => :start_term 
  	remove_foreign_key :banner_updates, :column => :end_term
  	
 	change_table :banner_updates do |t|
		t.datetime :upload_date
		t.remove :start_term
		t.remove :end_term
	end
  end
end
