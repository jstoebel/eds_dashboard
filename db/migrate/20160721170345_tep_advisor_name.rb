class TepAdvisorName < ActiveRecord::Migration
  def up

    change_table :tep_advisors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
    end

  end

  def down
    change_table :tep_advisors do |t|
      t.remove :first_name
      t.remove :last_name
    end

  end
end
