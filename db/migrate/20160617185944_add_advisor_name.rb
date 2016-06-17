class AddAdvisorName < ActiveRecord::Migration
  def up

    change_table :tep_advisors do |t|
        t.string :name, :after => :AdvisorBnum
        t.change :Salutation, :string, :null => true
        t.change :user_id, :integer, :null => true
    end

  end

  def down
    change_table :tep_advisors do |t|
        t.change :user_id, :integer, :null => false
        t.change :Salutation, :string, :null => false
        t.remove :name
    end
  end
end
