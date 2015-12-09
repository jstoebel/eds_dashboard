class CreateAdvisorAssignments < ActiveRecord::Migration
  def change
    create_table :advisor_assignments do |t|

      t.timestamps
    end
  end
end
