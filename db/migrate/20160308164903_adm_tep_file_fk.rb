class AdmTepFileFk < ActiveRecord::Migration
  def up
    #drop file columns
    remove_attachment :adm_tep, :letter

    #add fk pointing to student_files
    change_table :adm_tep do |t|
        t.integer :student_file_id
    end
    add_foreign_key :adm_tep, :student_files

  end

  def down

    remove_foreign_key :adm_tep, :student_files
    change_table :adm_tep do |t|
        t.remove :student_file_id
    end

    add_attachment :adm_tep, :letter
  end
end
