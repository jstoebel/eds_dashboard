class CreatePraxisSubTemps < ActiveRecord::Migration
  def up
    create_table :praxis_sub_temps do |t|

      # save all of the data. We don't presently expect a user error leading
      # to incorrect data here, only that the praxis_result won't know its
      # parent student
      t.integer :praxis_result_temp_id, limit: 4,   null: false
      t.integer :sub_number,       limit: 4
      t.string  :name,             limit: 255
      t.integer :pts_earned,       limit: 4
      t.integer :pts_aval,         limit: 4
      t.integer :avg_high,         limit: 4
      t.integer :avg_low,          limit: 4
    end

    add_foreign_key :praxis_sub_temps, :praxis_result_temps

  end

  def down
    remove_foreign_key :praxis_sub_temps, :praxis_result_temps
    drop_table :praxis_sub_temps

  end
end
