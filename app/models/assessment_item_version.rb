# == Schema Information
#
# Table name: assessment_item_versions
#
#  id                    :integer          not null, primary key
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  item_code             :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#
# Indexes
#
#  assessment_item_versions_assessment_item_id_fk     (assessment_item_id)
#  assessment_item_versions_assessment_version_id_fk  (assessment_version_id)
#

class AssessmentItemVersion < ActiveRecord::Base

    has_many :assessment_versions
    has_many :assessment_items

    validates :item_code, :presnce => true
end
