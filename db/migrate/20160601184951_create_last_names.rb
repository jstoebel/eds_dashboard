class CreateLastNames < ActiveRecord::Migration
  def up
    create_table :last_names do |t|
    	t.integer :student_id
    	t.string :last_name
  		t.timestamps
    end

    add_foreign_key :last_names, :students
  end

  def down
  	remove_foreign_key :last_names, :students

  	drop_table :last_names
  end
end
