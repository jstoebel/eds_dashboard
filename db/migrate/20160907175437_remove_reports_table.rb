class RemoveReportsTable < ActiveRecord::Migration
  def up
    drop_table :reports
  end

  def down
    create_table :reports do |t|

      t.timestamps null: false
    end
  end
end
