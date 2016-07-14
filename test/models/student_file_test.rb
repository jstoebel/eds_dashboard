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

    test "diallows duplicate file names for same student" do
        f = FactoryGirl.create :student_file
        f2 = StudentFile.new(f.attributes.except("id"))
        assert_not f2.valid?
    end

    # test "can handle duplicate files" do
    #
    #     f = FactoryGirl.create :student_file
    #     f2 = StudentFile.new(f.attributes.except("id"))
    #
    #     # puts StudentFile.where({:student_id => f2.student_id, :doc_file_name => f2.doc_file_name}).first.inspect
    #
    #     p "BEFORE THE SAVE"
    #     puts f.inspect
    #     puts f2.inspect
    #
    #     p "AFTER THE SAVE"
    #     assert f2.valid?, f2.errors.full_messages
    #
    #     puts f2.inspect
    #
    #     extension = File.extname f.doc_file_name
    #     base = File.basename f.doc_file_name, extension
    #
    #     assert_equal "#{base}-#{1}#{extension}", f2.doc_file_name
    #
    # end

end
