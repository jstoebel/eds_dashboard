class CreateDowntimes < ActiveRecord::Migration
  def change
    create_table :downtimes do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :reason
      t.timestamps null: false
    end
  end
end
