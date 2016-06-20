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

    has_many :assessment_versions    #might be present on any version
    has_many :item_levels
    
    belongs_to :student_scores
    

    validates_presence_of :slug, :name
end
