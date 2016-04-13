require 'paperclip'
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :student_file do
    sequence(:id) { |i| i }
    association :student, factory: :student
    doc { fixture_file_upload(File.new(Rails.root.join("test", "factories", "test_doc.docx"))) }
  end
end