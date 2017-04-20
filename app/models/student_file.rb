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

class StudentFile < ApplicationRecord
	belongs_to :student
  before_save :check_file_unique

	has_attached_file :doc,
	  :url => "/student_file/:id/download",		#passes AltID
	  :path => ":rails_root/storage/student_files/#{Rails.env}/:bnum/:basename.:extension",
	  :preserve_files => true,
	  :keep_old_files => true

  	validates :doc, attachment_presence: true
  	validates_attachment_file_name :doc, :matches => [/doc\Z/, /docx\Z/, /pdf\Z/, /txt\Z/],
    	:message => "Attached file must be a Word Document, PDF or plain text document."

    # validates :doc_file_name, :uniqueness => {scope: :student_id, message: "Document with this name already exists for this student"}

	scope :active, lambda {where(:active => true) }

    private
    def check_file_unique
      # this is VERY unlikly but let's make sure that we never are trying to save
      # over a file with the same name.

      dir = File.dirname(self.doc.path) # the directory to look in.
      ext = File.extname self.doc_file_name # the extension of the file
      basename = File.basename self.doc_file_name, ext # just the basename

      all_paths = Dir[File.join(dir, '*')] # full paths of all files in same directory

      contents = all_paths.map do |path| # name of just the file
        File.basename path
      end

      attempted_name = "#{basename}#{ext}" # the orginal shouldn't have a 1 at the end.
      version = 1 # the version to try appending
      while true
        break if !contents.include? attempted_name

        # that file name isn' uniqe. Let's try something else
        version += 1
        attempted_name = "#{basename}-#{version}#{ext}"

      end

      self.doc_file_name = attempted_name

    end

end
