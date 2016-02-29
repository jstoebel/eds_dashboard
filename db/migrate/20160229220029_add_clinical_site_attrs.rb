class AddClinicalSiteAttrs < ActiveRecord::Migration
  def up
    change_table :clinical_sites do |t|
        t.string :phone
        t.string :receptionist
        t.string :website
    end
  end

  def down
    change_table :clinical_sites do |t|
        t.remove :phone
        t.remove :receptionist
        t.remove :website
    end
  end
end
