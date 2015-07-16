class CreatePraxisTests < ActiveRecord::Migration
  def change
    create_table :praxis_tests do |t|

      t.timestamps
    end
  end
end
