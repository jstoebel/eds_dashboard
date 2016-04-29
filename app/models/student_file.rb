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

	before_save :clear_name

	has_attached_file :doc, 
	  :url => "/student_file/:altid/download",		#passes AltID 
	  :path => ":rails_root/public/student_files/:bnum/:basename.:extension",
	  :preserve_files => true,
	  :keep_old_files => true
	  
  validates_attachment_file_name :doc, :matches => [/doc\Z/, /docx\Z/, /pdf\Z/, /txt\Z/],
    :message => "Attached file must be a Word Document, PDF or plain text document."

	scope :active, lambda {where(:active => true) }

	private
	def clear_name
		#checks if file_name will not result in replacing a file.
		#creates an available file name if it will

		if self.new_record? and has_duplicate(self.doc_file_name, self.student_id)
			#try alternatives by appending a number to the end of the file
			#example file_1, file_2 etc

			num = 1
			name = File.basename self.doc_file_name, ".*"
			ext = File.extname self.doc_file_name
			while true
				new_name = [name, num.to_s].join('_')+ext
				if not has_duplicate(new_name, self.student_id)	#does this name check out?
					break
				else
					num += 1
				end
					
			end

			self.doc_file_name = new_name
		end
		
	end

	def has_duplicate(file_name, bnum)
		#checks if <file_name> exists in the database for student
		#with Bnum
		#file name: complete file name (no path)
		#bnum: student's B#
		#returns true if the file exists for this student.

		matches = StudentFile.where(student_id: bnum, doc_file_name: file_name).size
		return matches > 0
	end

end
