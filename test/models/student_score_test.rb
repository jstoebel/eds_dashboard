# == Schema Information
#
# Table name: student_scores
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  item_level_id           :integer
#  scored_at               :datetime
#  created_at              :datetime
#  updated_at              :datetime
#  student_score_upload_id :integer
#

require 'test_helper'
require 'mocks/sheet'

class StudentScoreTest < ActiveSupport::TestCase

  describe "validations" do
    before do
      @stu_score = StudentScore.new
      @stu_score.valid?
    end
    [:student_id, :item_level_id, :scored_at].each do |attr|
      test attr do
        assert_equal ["can't be blank"], @stu_score.errors[attr]

      end
    end
  end

  test "format_types" do
    assert_equal [:moodle, :qualtrics], StudentScore.format_types
  end

  describe "import_moodle" do

    before do
      # template for sheet data
      @sheet_data = [
        ["Admission to Teacher Education Program –F2016"],
        ["Admission to TEP: Reader 1"],
        ["Rubric: Admission to TEP"],
        [],
        ["Student", nil, nil, nil, "Reasons", nil, nil, "Teaching Experiences ", nil, nil, "Grading info", nil],
        ["First name", "Last name", "Student ID", "Username", "Score", "Definition", "Feedback", "Score", "Definition", "Feedback", "Graded by", "Time graded"]
      ]

      @xlsx = mock('xlsx')
      @spreadsheet = mock('spreadsheet')
      @sheet = Sheet.new @sheet_data

      Roo::Spreadsheet.stubs(:open).with(@xlsx).returns(@spreadsheet)
      @spreadsheet.stubs(:sheet).with(0).returns(@sheet)

      @students = FactoryGirl.create_list :student, 2
      @assessment = FactoryGirl.create :assessment
      assessment_items = FactoryGirl.create_list :assessment_item, 2, :assessment => @assessment
      @levels = assessment_items.map {|item| FactoryGirl.create :item_level, :assessment_item => item}

      @students.each_with_index do |stu, i|
        row = [
          stu.FirstName,
          stu.LastName,
          stu.Bnum,
          stu.LastName, # username
        ]
        @levels.each do |lvl|
          row += [lvl.level, lvl.descriptor, nil]
        end

        row += ["teachername", DateTime.now.strftime("%A, %B %e, %Y, %l:%M %P")]
        @sheet_data << row
      end

    end

    test "successful import" do

      counts = StudentScore.import_moodle @xlsx, @assessment
      binding.pry
      assert_equal [2, 4], counts
      assert_equal 4, StudentScore.count

    end # test

    test "can't find student" do

      # mutate data to raise desired error
      @sheet_data[6][2] = "bad bnum"

      err = assert_raises RuntimeError do
        StudentScore.import_moodle @xlsx, @assessment
      end
      # err = assert_raises RuntimeError { StudentScore.import_moodle @xlsx, @assessment }
      stu = @students.first
      stu_name = "#{stu.FirstName} #{stu.LastName}"
      assert_equal "Could not find student at row 7: #{ stu_name }", err.message

    end # test can't find student

    test "bad time stamp" do

      # mutate data to raise desired error
      @sheet_data[6][11] = Date.today.to_s

      err = assert_raises RuntimeError do
        StudentScore.import_moodle @xlsx, @assessment
      end

      assert_equal "Improper timestamp at row 7", err.message
    end # test bad time stamp

    test "bad descriptor" do

      @sheet_data[6][5] = "bad data"

      err = assert_raises RuntimeError do
        StudentScore.import_moodle @xlsx, @assessment
      end

      assert_equal "Improper descriptor at cell F7: #{@sheet_data[6][5]}", err.message

    end # test bad descriptor

    test "duplicate student score" do

      # make both rows for the same student
      @sheet_data[7][2] = @sheet_data[6][2]

      err = assert_raises RuntimeError do
        StudentScore.import_moodle @xlsx, @assessment
      end
      expected_msg = "Error at row 8: Validation failed: Student Duplicate record: student has already been scored for this item with this time stamp."
      assert_equal  expected_msg, err.message

    end # test duplicate student score

  end # outer describe

end
