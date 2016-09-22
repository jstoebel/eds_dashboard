# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text(65535)
#

require 'test_helper'

class ProgExitTest < ActiveSupport::TestCase
	fixtures :all

	test "scope by_term" do
    ProgExit.delete_all
    pe = FactoryGirl.create :successful_prog_exit
    assert_equal ProgExit.where("ExitTerm = ?", pe.ExitTerm), ProgExit.by_term(pe.ExitTerm)
  end

  describe "post validations" do
    before do
      @pe = FactoryGirl.create :successful_prog_exit
    end

		describe "good_gpa" do

			describe "returns true" do

				test "overall good" do
					@pe.GPA = 2.5
					@pe.GPA_last60 = 2.99
					assert @pe.good_gpa?
				end

				test "last60 good" do
					@pe.GPA = 2.49
					@pe.GPA_last60 = 3.0
					assert @pe.good_gpa?
				end

				test "both good" do
					assert @pe.good_gpa?
				end
			end

			describe "returns false" do
				test "both bad" do
					@pe.GPA = 2.49
					@pe.GPA_last60 = 2.99
					assert_not @pe.good_gpa?
				end
			end

			describe "returns nil" do

				test "overall nil" do
					@pe.GPA = nil
					@pe.GPA_last60 = 2.99
					assert @pe.good_gpa?.nil?
				end

				test "last60 nil" do
					@pe.GPA = 2.49
					@pe.GPA_last60 = nil
					assert @pe.good_gpa?.nil?
				end

				test "last60 nil" do
					@pe.GPA = nil
					@pe.GPA_last60 = nil
					assert @pe.good_gpa?.nil?
				end

			end
		end

    test "adds term" do
      actual_term = BannerTerm.current_term({:date => @pe.ExitDate,
        :exact => false, :plan_b => :back})
      assert_equal @pe.ExitTerm, actual_term.id
    end

    test "sets gpas" do
      assert_equal 4.0, @pe.GPA
      assert_equal 4.0, @pe.GPA_last60
    end

  end

  test "scope by_term" do
  	expected = ProgExit.where("ExitTerm= ?", 201511).to_a
  	actual = ProgExit.by_term(201511).to_a
  	assert_equal(expected, actual)
  end

	test "blank bnum bad" do
		prog_exit = FactoryGirl.create :successful_prog_exit
		prog_exit.student_id = nil
		prog_exit.valid?
		assert_equal(["Please select a student."], prog_exit.errors[:student_id])
	end

	test "require completer for recommendation" do
		prog_exit = FactoryGirl.create :successful_prog_exit
		prog_exit.ExitCode_ExitCode = "1826"
		prog_exit.valid?
		assert_equal(["Student may not be recommended for certificaiton unless they have sucessfully completed the program."], prog_exit.errors[:RecommendDate])
	end


end
