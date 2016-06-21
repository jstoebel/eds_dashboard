# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  version_num   :integer
#  created_at    :datetime
#  updated_at    :datetime
#

=begin
Represents a specific version of a paticular assessment
=end

class AssessmentVersion < ActiveRecord::Base

    ### ASSOCIATIONS ###
    belongs_to :assessment
    belongs_to :student_score
    #has_many :assessment_items

    before_save :set_version_num

    def set_version_num
        syblings = AssessmentVersion.where(assessment_id: self.assessment_id)
        self.version_num = syblings.size + 1
    end
end
