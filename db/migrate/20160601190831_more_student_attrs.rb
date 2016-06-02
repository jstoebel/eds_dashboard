class MoreStudentAttrs < ActiveRecord::Migration

  def up
  	change_table :students do |t|
  		t.text :withdrawals
  		t.integer :term_graduated
  		t.string :gender
  		t.string :race
  		t.boolean :hispanic
      t.string :concentration1, :after => "CurrentMajor1"
      t.string :concentration2, :after => "CurrentMajor2"
      t.integer :term_expl_major
      t.integer :term_major
      t.remove :ProgStatus
  		t.remove :PraxisICohort
  		t.remove :PraxisIICohort
      t.remove :TermMajor

  	end
  	add_foreign_key :students, :banner_terms, :column => :term_graduated, :primary_key => :BannerTerm
    add_foreign_key :students, :banner_terms, :column => :term_expl_major, :primary_key => :BannerTerm
    add_foreign_key :students, :banner_terms, :column => :term_major, :primary_key => :BannerTerm
  end

  def down
  	remove_foreign_key :students, :name => "students_term_graduated_fk"
    remove_foreign_key :students, :name => "students_term_expl_major_fk"
    remove_foreign_key :students, :name => "students_term_major_fk"

  	change_table :students do |t|
      t.integer :TermMajor
      t.string  "PraxisICohort",    limit: 45
	    t.string  "PraxisIICohort",   limit: 45
    	t.string  "ProgStatus",       limit: 45,  default: "Prospective"
      t.remove :term_expl_major
      t.remove :term_major
      t.remove :concentration1
      t.remove :concentration2
    	t.remove :hispanic
    	t.remove :race
    	t.remove :gender
    	t.remove :term_graduated
    	t.remove :withdrawals

  	end

  end
end
