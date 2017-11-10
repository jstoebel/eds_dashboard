class AssessmentSlug < ActiveRecord::Migration[5.0]
  def up
    add_column :assessments, :slug, :string, null: false
  end

  def down
    remove_column :assessments, :slug
  end
end
