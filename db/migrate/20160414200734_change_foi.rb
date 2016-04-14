class ChangeFoi < ActiveRecord::Migration
  def up
    # drop_table :forms_of_intention

    create_table :forms_of_intention, force: true do |t|
        t.string    :student_id
        t.datetime  :date_completing
        t.boolean   :new_form
        t.boolean   :seek_cert
        t.string    :program_id        #one record for each program!
        t.timestamps
    end
    add_foreign_key :forms_of_intention, :students, primary_key: "Bnum" 
  end

  def down

    drop_table :forms_of_intention
    create_table "forms_of_intention", primary_key: "FormID", force: true do |t|
        t.string  "Student_Bnum",   limit: 9,  null: false
        t.string  "DateCompleting", limit: 45, null: false
        t.boolean "NewForm"
        t.boolean "SeekCert"
        t.string  "CertArea",       limit: 45
    end
    add_index "forms_of_intention", ["Student_Bnum"], name: "fk_FormofIntention_Student1_idx", using: :btree
  end
end
