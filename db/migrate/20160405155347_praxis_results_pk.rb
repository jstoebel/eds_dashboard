class PraxisResultsPk < ActiveRecord::Migration
  def up

    change_table :praxis_results do |t|
        t.change :id, :string
    end
  end

  def down
    change_table :praxis_results do |t|
        t.change :id, :integer
    end
  end
end
