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

=begin

represents a type of assessment, example Admission to Student Teaching.
specific versions of an assessment are modeled in AssessmentVersion

=end

class Assessment < ActiveRecord::Base
    before_destroy :can_destroy

    ### ASSOCIATIONS ###
    has_many :assessment_items
    has_many :item_levels, :through => :assessment_items
    has_many :student_scores, :through => :item_levels

    ### VALIDATIONS ###
    validates :name, :presence => true

    def repr
        return self.name
    end

    def has_scores
      self.student_scores.size > 0
    end

    def can_destroy
        #returns false if has scores and cannot delete
        #returns true if does not have scores and can delete
        if self.has_scores == true
            return false
        else
            return true
        end
    end
end
