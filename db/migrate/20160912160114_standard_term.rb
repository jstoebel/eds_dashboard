class StandardTerm < ActiveRecord::Migration
  def up
    add_column :banner_terms, :standard_term, :boolean
  end

  def down
    remove_column :banner_terms, :standard_term
  end
end
