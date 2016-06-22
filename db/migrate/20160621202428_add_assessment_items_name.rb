class AddAssessmentItemsName < ActiveRecord::Migration
  def up
    change_table :assessment_items do |t|
      t.string :name
    end
  end
  
  def down
    change_table :assessment_items do |t|
      t.remove :name
    end
  end
end