class CreatePraxisPreps < ActiveRecord::Migration
  def change
    create_table :praxis_preps do |t|

      t.timestamps
    end
  end
end
