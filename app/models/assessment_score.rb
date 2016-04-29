# == Schema Information
#
# Table name: assessment_scores
#
#  id                    :integer          not null, primary key
#  student_assessment_id :integer          not null
#  assessment_item_id    :integer          not null
#  score                 :integer
#  created_at            :datetime
#  updated_at            :datetime
#
# Indexes
#
#  assessment_scores_assessment_item_id_fk     (assessment_item_id)
#  assessment_scores_student_assessment_id_fk  (student_assessment_id)
#

class AssessmentScore < ActiveRecord::Base

    belongs_to :student_assessment
    belongs_to :assessment_item
end
