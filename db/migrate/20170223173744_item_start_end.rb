class ItemStartEnd < ActiveRecord::Migration
  def up

    change_table :assessment_items do |t|
      t.integer :start_term, after: :slug
      t.integer :end_term, after: :start_term
    end

    [:start_term, :end_term].each do |col|
      add_foreign_key :assessment_items, :banner_terms, column: col, primary_key: :BannerTerm
    end
  end

  def down

    [:start_term, :end_term].each do |col|
      remove_foreign_key :assessment_items, column: col
    end

    change_table :assessment_items do |t|
      t.remove :start_term
      t.remove :end_term
    end

  end
end
