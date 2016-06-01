class MoreStudentAttrs < ActiveRecord::Migration

  def up
  	change_table :students do |t|
  		t.text :withdrawals
  		t.integer :term_graduated
  		t.string :gender
  		t.string :race
  		t.boolean :hispanic
  		t.remove :ProgStatus
  		t.remove :PraxisICohort
  		t.remove :PraxisIICohort
      t.remove :PrevLast
  	end
  	add_foreign_key :students, :banner_terms, :column => :term_graduated, :primary_key => :BannerTerm
  end

  def down
  	remove_foreign_key :students, :name => "students_term_graduated_fk"
  	change_table :students do |t|
	    t.string :PrevLast
      t.string  "PraxisICohort",    limit: 45
	    t.string  "PraxisIICohort",   limit: 45
    	t.string  "ProgStatus",       limit: 45,  default: "Prospective"
    	t.remove :hispanic
    	t.remove :race
    	t.remove :gender
    	t.remove :term_graduated
    	t.remove :withdrawals
  	end

  end
end
