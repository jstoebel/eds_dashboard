class PraxisResultsDropAltid < ActiveRecord::Migration
  def up
    change_table :praxis_results do |t|
      t.remove :AltID
    end
  end 

  def down
    change_table :praxis_results do |t|
      t.integer :AltID, null: false, uniqueness: true
    end
  end

end
