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

=begin
represents a single item that can belong to any number of different assessments
=end

class AssessmentItem < ActiveRecord::Base

    has_many :student_scores
    has_many :assessment_versions, :through => :assessment_item_versions
    has_many :item_levels

    validates :slug, presence: true
end
