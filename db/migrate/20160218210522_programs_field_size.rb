class ProgramsFieldSize < ActiveRecord::Migration
  def up
    change_table :programs do |t|
        t.change :EPSBProgName, :string, limit: 100  
    end
  end

  def down
    change_table :programs do |t|
        t.change :EPSBProgName, :string, limit: 45  
    end
  end
end
