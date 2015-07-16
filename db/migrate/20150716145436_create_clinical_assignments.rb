class CreateClinicalAssignments < ActiveRecord::Migration
  def change
    create_table :clinical_assignments do |t|

      t.timestamps
    end
  end
end
