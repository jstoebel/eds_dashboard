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

require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

class StudentFileTest < ActiveSupport::TestCase

    test "valid file extension" do

        file = FactoryGirl.build :student_file, {:active => true,
                :doc => fixture_file_upload('test_file.txt')
            }
        assert file.valid?, file.errors.full_messages
    end

    test "invalid file exension" do
      file = FactoryGirl.build :student_file, {:active => true,
              :doc => fixture_file_upload('badfile.bad')
            }
      file.valid?
      assert_includes file.errors[:doc], "Attached file must be a Word Document, PDF or plain text document."
    end

    test "scope active" do
        files = FactoryGirl.create_list :student_file, 5
        actual = StudentFile.all.active
        assert_equal files.to_a.sort, actual.to_a.sort
    end

    test "can handle duplicate files" do

        f = FactoryGirl.create :student_file
        f2 = StudentFile.create(f.attributes.except("id"))
        extension = File.extname f.doc_file_name
        base = File.basename f.doc_file_name, extension
        assert_equal "#{base}-#{2}#{extension}", f2.doc_file_name

    end

end
