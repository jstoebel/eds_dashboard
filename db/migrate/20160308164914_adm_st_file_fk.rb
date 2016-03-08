class AdmStFileFk < ActiveRecord::Migration
  def up
    #drop file columns
    remove_attachment :adm_st, :letter

    #add fk pointing to student_files
    change_table :adm_st do |t|
        t.integer :student_file_id
    end
    add_foreign_key :adm_st, :student_files

  end

  def down
    remove_foreign_key :adm_st, :student_files
    change_table :adm_st do |t|
        t.remove :student_file_id
    end

    add_attachment :adm_st, :letter
  end
end
