class TepAdvisorEmail < ActiveRecord::Migration
  def up
    add_column :tep_advisors, :email, :string
  end

  def down
    remove_column :tep_advisors, :email
  end
end
