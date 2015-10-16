class StudentFile < ActiveRecord::Base

	belongs_to :student, {:foreign_key => 'Student_Bnum'}

	has_attached_file :doc, 
  :url => "/student_file/:altid/download",		#passes AltID 
  :path => ":rails_root/public/:bnum/misc_docs/:basename.:extension",
  :keep_old_files => true
	do_not_validate_attachment_file_type :doc

	scope :active, lambda {where(:active => true) }

end
