# == Schema Information
#
# Table name: assessment_scores
#
#  id                         :integer          not null, primary key
#  student_assessment_id      :integer          not null
#  assessment_item_version_id :integer          not null
#  score                      :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

=begin
represents a single score on a student's assessment
=end

class AssessmentScore < ActiveRecord::Base

    belongs_to :student_assessment
    belongs_to :assessment_item_version

    validates :student_assessment_id, {
        presence: true
    }

    validates :assessment_item_version_id, {
        presence: true
    }

    validate :valid_item, :if => Proc.new{ |record| record.errors.empty? }


    def valid_item 
      #TODO can't point to an AIV if its parent student_assessment isn't of the same assessment_version
      return true
    end

end
