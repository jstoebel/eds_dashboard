class AddClinicalTeacherAttrs < ActiveRecord::Migration
  def up
    change_table :clinical_teachers do |t|
        t.datetime :begin_service
        t.datetime :epsb_training
        t.datetime :ct_record
        t.datetime :co_teacher_training
    end
  end
  
  def down
    change_table :clinical_teachers do |t|
        t.remove :begin_service
        t.remove :epsb_training
        t.remove :ct_record
        t.remove :co_teacher_training
    end
  end
end
