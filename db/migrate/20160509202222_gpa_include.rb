class GpaInclude < ActiveRecord::Migration
  def up

    change_table :transcript do |t|
        t.remove :gpa_credits
        t.boolean :gpa_include, :null => false
    end
  end

  def down
    change_table :transcript do |t|
        t.float :gpa_credits
        t.remove :gpa_include
    end
  end
end
