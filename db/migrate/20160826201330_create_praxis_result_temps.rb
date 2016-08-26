class CreatePraxisResultTemps < ActiveRecord::Migration
  def up
    create_table :praxis_result_temps do |t|

      # the identifying information
      t.string :first_name
      t.string :last_name

      # the saved information
      t.integer :student_id # probobly missing
      t.integer :praxis_test_id
      t.datetime :test_date
      t.integer :test_score
      t.integer :best_score
    end

  end

  def down
    drop_table :praxis_result_temps
  end
end
