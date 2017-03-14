class CreateAdmFiles < ActiveRecord::Migration
  def up
    create_table :adm_files do |t|
      t.references :adm_tep
      t.references :student_file
      t.timestamps null: false
    end
  end

  def down
    drop_table :adm_files
  end
end
