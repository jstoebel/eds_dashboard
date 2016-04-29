# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text
#  level              :integer
#  created_at         :datetime
#  updated_at         :datetime
#
# Indexes
#
#  item_levels_assessment_item_id_fk  (assessment_item_id)
#

class ItemLevel < ActiveRecord::Base

    belongs_to :assessment_item

    validates :descriptor, presence: true
    validates :level, presence: true
end
