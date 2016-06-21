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

  test "not valid object, validations failed" do
    assess = Assessment.new
    assert_not assess.valid?
    assert_equal [:name], assess.errors.keys
    assert_equal [:name].map{|i| [i, ["can't be blank"]]}.to_h, 
      assess.errors.messages
  end
end