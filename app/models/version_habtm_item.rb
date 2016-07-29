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
    belongs_to :assessment_version
    belongs_to :assessment_item
    
    validates_presence_of :assessment_version_id, :assessment_item_id
end
