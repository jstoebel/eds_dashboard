class AddStandardTerm < ActiveRecord::Migration
  def up
    add_column :banner_terms, :standard_term, :boolean
  end

  def down
    add_column :banner_terms, :standard_term, :boolean
  end
end
