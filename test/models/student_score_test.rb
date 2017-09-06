# == Schema Information
#
# Table name: student_scores
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  item_level_id :integer
#  scored_at     :datetime
#  created_at    :datetime
#  updated_at    :datetime
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

end
