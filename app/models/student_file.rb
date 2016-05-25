# == Schema Information
#
# Table name: student_files
#
#  student_id       :integer          not null
#  id               :integer          not null, primary key
#  active           :boolean          default(TRUE)
#  doc_file_name    :string(100)
#  doc_content_type :string(100)
#  doc_file_size    :integer
#  doc_updated_at   :datetime
#

class StudentFile < ActiveRecord::Base

	belongs_to :student

	has_attached_file :doc, 
	  :url => "/student_file/:id/download",		#passes AltID 
	  :path => ":rails_root/public/student_files/#{Rails.env}/:bnum/:basename.:extension",
	  :preserve_files => true,
	  :keep_old_files => true
	  
  	validates :doc, attachment_presence: true
  	validates_attachment_file_name :doc, :matches => [/doc\Z/, /docx\Z/, /pdf\Z/, /txt\Z/],
    	:message => "Attached file must be a Word Document, PDF or plain text document.",
    	:uniqueness => {:scope => :student_id, :message => "A file with this name already exists for this student."}

	scope :active, lambda {where(:active => true) }

end
