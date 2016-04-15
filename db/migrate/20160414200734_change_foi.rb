class ChangeFoi < ActiveRecord::Migration
  def up
    drop_table :forms_of_intention

    create_table :forms_of_intention, force: true do |t|
        t.string    :student_id,        null: false
        t.datetime  :date_completing
        t.boolean   :new_form
        t.integer   :major_id               #different from program (PE/Health is one option)
        t.boolean   :seek_cert
        t.boolean   :eds_only
        t.timestamps
    end

    add_foreign_key :forms_of_intention, :students, primary_key: :Bnum

    create_table :majors do |t|
        t.string :name
    end

    add_foreign_key :forms_of_intention, :majors 

  end

  def down

    drop_table :forms_of_intention
    create_table "forms_of_intention", primary_key: "FormID", force: true do |t|
        t.string  "Student_Bnum",   limit: 45,  null: false
        t.string  "DateCompleting", limit: 45, null: false
        t.boolean "NewForm"
        t.boolean "SeekCert"
        t.string  "CertArea",       limit: 45
    end
    add_index "forms_of_intention", ["Student_Bnum"], name: "fk_FormofIntention_Student1_idx", using: :btree
  
    drop_table :majors

  end
end
