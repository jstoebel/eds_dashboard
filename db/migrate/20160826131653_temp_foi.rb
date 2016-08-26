class TempFoi < ActiveRecord::Migration
  def up
    create_table :temp_foi do |t|
      t.string :student_id
      t.string :date_completing
      t.boolean :new_form
      t.integer :major_id
      t.boolean :seek_cert
      t.boolean :eds_only
      t.string :foi_errors
      t.timestamps :created_at
    end
    add_foreign_key :temp_foi, :students, primary_key: :Bnum
  end
  
  def down

    drop_table :temp_foi
    create_table "temp_foi" do |t|
        t.string  "Student_Bnum",   limit: 45
        t.string  "DateCompleting", limit: 45
        t.boolean "NewForm"
        t.boolean "SeekCert"
        t.string  "CertArea",       limit: 45
    end
    add_index "temp_foi", ["Student_Bnum"], name: "fk_FormofIntention_Student1_idx", using: :btree
    
    drop_table :majors
    
  end
  
end
