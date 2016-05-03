class AlterPraxisTests < ActiveRecord::Migration
  def up

    change_table :praxis_tests do |t|
        t.change :Program_ProgCode, :integer, :null => true
        t.change :TestName, :string, :length => 255

        #fix sub test lengths
        (1..7).each do |s|
            t.change "Sub#{s}".to_sym, :string, :length => 255
        end
    end
  end

  def down

    change_table :praxis_tests do |t|
        t.change :Program_ProgCode, :integer, :null => false
        t.change :TestName, :string, :length => 45

        #sub test lengths
        (1..7).each do |s|
            t.change "Sub#{s}".to_sym, :string, :length => 100
        end

    end
  end
end
