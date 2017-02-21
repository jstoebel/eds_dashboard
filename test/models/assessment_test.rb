# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase

  test "Should destroy dependent versions" do
    ver = FactoryGirl.create :assessment_version
    assess = ver.assessment
    assess.destroy!
    assert assess.destroyed?
    assert_not AssessmentVersion.exists?(ver.id)
  end

  test "not valid object, needs name" do
    assess = Assessment.new
    assert_not assess.valid?
    assert_equal [:name].map{|i| [i, ["can't be blank"]]}.to_h,
      assess.errors.messages
  end

  test "versions" do
    ver = FactoryGirl.create :version_with_items
    assess = ver.assessment
    assert_equal assess.versions, assess.assessment_versions
  end

  test "current_version" do
    ver = FactoryGirl.create :version_with_items
    assess = ver.assessment
    current = assess.versions.order(:created_at => :asc).last
    assert_equal assess.current_version, current
  end

  test "has_scores" do
    ver = FactoryGirl.create :version_with_items
    assess = ver.assessment
    score = assess.assessment_versions.select { |v| v.student_scores.present?}.size > 0
    assert_equal assess.has_scores, score
  end

  test "repr" do
    assessment = FactoryGirl.create :assessment
    assert_equal assessment.name, assessment.repr
  end
end
