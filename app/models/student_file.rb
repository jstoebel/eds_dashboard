class StudentFile < ActiveRecord::Base

	belongs_to :student

	has_attached_file :doc, 
  :url => "/student_file/:altid/download",		#passes AltID 
  :path => ":rails_root/public/:bnum/misc_docs/:basename.:extension"

	do_not_validate_attachment_file_type :doc

	scope :active, lambda {where(:active => true) }

end
