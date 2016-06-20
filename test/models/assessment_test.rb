# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "not valid object, validations failed" do
    assess = Assessment.new
    assert_not assess.valid?
    assert_equal [:name], assess.errors.keys
  end
end
