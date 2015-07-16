class CreatePraxisResults < ActiveRecord::Migration
  def change
    create_table :praxis_results do |t|

      t.timestamps
    end
  end
end
