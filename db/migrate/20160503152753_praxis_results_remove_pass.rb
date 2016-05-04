class PraxisResultsRemovePass < ActiveRecord::Migration
  def up

    remove_column :praxis_results, :pass
  end

  def down

    add_column :praxis_results, :pass, :boolean
      
  end
end
