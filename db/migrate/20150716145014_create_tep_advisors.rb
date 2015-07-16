class CreateTepAdvisors < ActiveRecord::Migration
  def change
    create_table :tep_advisors do |t|

      t.timestamps
    end
  end
end
