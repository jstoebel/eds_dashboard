class CreateStFiles < ActiveRecord::Migration
  def up
    create_table :st_files do |t|
      t.references :adm_tep
      t.references :student_file
      t.timestamps null: false
    end
  end

  def down
    drop_table, :st_files
  end
end
