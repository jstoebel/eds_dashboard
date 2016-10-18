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
    before_save :check_file_unique

	has_attached_file :doc,
	  :url => "/student_file/:id/download",		#passes AltID
	  :path => ":rails_root/current/public/student_files/#{Rails.env}/:bnum/:basename.:extension",
	  :preserve_files => true,
	  :keep_old_files => true

  	validates :doc, attachment_presence: true
  	validates_attachment_file_name :doc, :matches => [/doc\Z/, /docx\Z/, /pdf\Z/, /txt\Z/],
    	:message => "Attached file must be a Word Document, PDF or plain text document."

    # validates :doc_file_name, :uniqueness => {scope: :student_id, message: "Document with this name already exists for this student"}

	scope :active, lambda {where(:active => true) }

    private
    def check_file_unique
        #if file isn't unique for this student, append a number to the file end (example letter.docx and letter-1.docx)

        match_count = StudentFile.where(:student_id => self.student.id, :doc_file_name => self.doc_file_name).where.not(id: self.id).size

        extension = File.extname self.doc_file_name
        base = File.basename self.doc_file_name, extension

        if match_count> 0
            self.doc_file_name = "#{base}-#{match_count}#{extension}"
        end
    end

end
