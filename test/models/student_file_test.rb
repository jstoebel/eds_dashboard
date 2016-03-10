require 'test_helper'
require 'paperclip'
include ActionDispatch::TestProcess

class StudentFileTest < ActiveSupport::TestCase

    test "valid file extension" do
        stu = Student.first
        file = StudentFile.new({
                :Student_Bnum => stu.id,
                :active => true,
                :doc => fixture_file_upload('test_file.txt')
            })
        assert file.valid?, file.errors.full_messages
    end

    test "ivalid file exension" do
        file = StudentFile.where('doc_file_name like "%.bad"').first
        file.valid?
        assert_includes file.errors[:doc], "Attached file must be a Word Document, PDF or plain text document."
    end

    test "scope active" do
        expected = StudentFile.where(:active => true)
        actual = StudentFile.all.active
        assert_equal expected.to_a, actual.to_a
    end

    test "can handle multiple files" do
        StudentFile.delete_all
        stu = Student.first
        file_name = "test_file.txt"
        name, ext = file_name.split('.')
        num_files = 3

        expected_names = [file_name] + (1..num_files-1).map {|i| "test_file_#{i}.txt"}

        num_files.times do |i|
            file = StudentFile.create({
                    :Student_Bnum => stu.id,
                    :active => true,
                    :doc => fixture_file_upload(file_name)
                })
        end

        actual_names = StudentFile.all.order(:id).map {|f| f.doc_file_name}

        assert_equal expected_names, actual_names.to_a    
    end  

end
