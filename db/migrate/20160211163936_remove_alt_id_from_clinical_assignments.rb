class RemoveAltIdFromClinicalAssignments < ActiveRecord::Migration
  def up
    change_table :clinical_assignments do |t|
      t.remove :AltID
    end
  end 

  def down
    change_table :clinical_assignments do |t|
      t.integer :AltID, null: false, uniqueness: true
    end
  end
end
