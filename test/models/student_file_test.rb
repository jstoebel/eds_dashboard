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
        stu = Student.first
        file = StudentFile.new({
                :student_id => stu.id,
                :active => true,
                :doc => fixture_file_upload('test_file.txt')
            })
        assert file.valid?, file.errors.full_messages
    end

    test "invalid file exension" do
        file = StudentFile.where('doc_file_name like "%.bad"').first
        file.valid?
        assert_includes file.errors[:doc], "Attached file must be a Word Document, PDF or plain text document."
    end

    test "scope active" do
        expected = StudentFile.where(:active => true)
        actual = StudentFile.all.active
        assert_equal expected.to_a, actual.to_a
    end

    test "cant have repeat names for same student" do 
        StudentFile.delete_all
        stu = Student.first
        FactoryGirl.create :student_file, :student_id => stu.id, :doc => fixture_file_upload("test_file.txt")
        assert_raises(ActiveRecord::RecordInvalid){FactoryGirl.create :student_file, :student_id => stu.id, 
            :doc => fixture_file_upload("test_file.txt")
        }

    end

end
