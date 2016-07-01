# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  name  <-- FYI: this is just annotation, it doesn't affect the model. 
# if its in the db, the model will know about it.
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

=begin
represents a single item that can belong to any number of different assessments
=end

class AssessmentItem < ActiveRecord::Base
    
    has_many :item_levels
    has_many :student_scores
    has_many :version_habtm_items
    has_many :assessment_versions, :through => :version_habtm_items
    
    validates_presence_of :name, :slug
end
