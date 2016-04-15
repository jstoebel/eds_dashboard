class StudentBnumString < ActiveRecord::Migration
  def change

    reversible do |dir|
      change_table :students do |t|
        dir.up { t.change :Bnum, :string, :limit => 45 }
        dir.down { t.change :Bnum, :integer }
      end
    end

  end
end
