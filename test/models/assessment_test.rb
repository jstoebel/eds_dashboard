# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)      not null
#

require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase

  test "not valid object, needs name" do
    assess = Assessment.new
    assert_not assess.valid?
    assert_equal ["can't be blank"], assess.errors[:name]
  end

  test "repr" do
    assessment = FactoryGirl.create :assessment
    assert_equal assessment.name, assessment.repr
  end
end
