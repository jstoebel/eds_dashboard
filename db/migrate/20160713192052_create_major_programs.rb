class CreateMajorPrograms < ActiveRecord::Migration
  def up
    create_table :major_programs do |t|
      t.integer :major_id
      t.integer :program_id
      t.timestamps
    end

    add_foreign_key :major_programs, :majors
    add_foreign_key :major_programs, :programs
  end

  def down
    drop_table :major_programs
  end
end
