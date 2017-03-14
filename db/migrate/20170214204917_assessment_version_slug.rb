class AssessmentVersionSlug < ActiveRecord::Migration
  def up
      change_table :assessment_versions do |t|
          t.string :slug, :length => 255, :after => :id
          t.datetime :retired_on, :after => :slug
      end
  end

  def down
      remove_column :assessment_versions, :slug
  end
end
