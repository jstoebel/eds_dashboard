class CreateAssessmentItems < ActiveRecord::Migration
  def up
    create_table :assessment_items do |t|
      t.string :slug
      t.string :name
      t.timestamps
      t.actable
    end
  end

  def down
    drop_table :assessment_items
  end
end
