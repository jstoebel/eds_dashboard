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
# Indexes
#
#  assessment_versions_assessment_id_fk  (assessment_id)
#

class AssessmentVersion < ActiveRecord::Base

    ### ASSOCIATIONS ###
    belongs_to :assessment
    has_many  :assessment_item_versions
    has_many :assessment_items, :through => :assessment_item_version
end
