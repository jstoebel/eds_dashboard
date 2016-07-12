class AddStandardTerm < ActiveRecord::Migration
  def up
    add_column :banner_terms, :standard, :boolean
  end

  def down
    remove_column :banner_terms, :standard
  end
end
