# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class AssessmentItem < ActiveRecord::Base

    belongs_to :assessment_item_version
    has_many :item_levels

    validates :slug, presence: true
end
