require 'test_helper'

class StudentScoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Object not valid, validations fail" do
    stu_scor=StudentScore.new
    assert_not stu_scor.valid?
    assert_equal [:student_id, 
      :assessment_version_id, 
      :assessment_item_id, 
      :item_level_id] ,
      stu_scor.errors.keys
    assert_equal [:student_id, :assessment_version_id, :assessment_item_id, :item_level_id].map{|i| [i, ["can't be blank"]]}.to_h, 
     stu_scor.errors.messages
  end
end
