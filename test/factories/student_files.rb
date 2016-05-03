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

require 'paperclip'
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :student_file do
    association :student, factory: :student
    doc { fixture_file_upload(File.new(Rails.root.join("test", "factories", "test_doc.docx"))) }
  end
end
