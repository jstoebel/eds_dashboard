class CreatePraxisUpdates < ActiveRecord::Migration
  def change
    create_table :praxis_updates do |t|

      t.timestamps
    end
  end
end
