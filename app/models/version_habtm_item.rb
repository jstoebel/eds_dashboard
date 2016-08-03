# == Schema Information
#
# Table name: version_habtm_items
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

=begin
=end

class VersionHabtmItem < ActiveRecord::Base
    before_validation :ver_locked
    before_destroy :ver_locked
    
    belongs_to :assessment_version
    belongs_to :assessment_item
    
    validates_presence_of :assessment_version_id, :assessment_item_id
    
    def ver_locked
        #returns false if version is locked and cannot be validated
        @version = AssessmentVersion.find(self.assessment_version_id)
        if @version.has_scores == true
            return false
        else
            return true
        end
    end
end
