class CreateAssessments < ActiveRecord::Migration
  def up
    create_table :assessments do |t|
      t.string :name        # name of the assessment
      t.text :description   # description of the assessment
      t.timestamps
    end
  end

  def down
    drop_table :assessments
  end
end
