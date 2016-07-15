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
    accepts_nested_attributes_for :item_levels
    
    validates_presence_of :name, :slug
    
    before_validation :check_scores #test that does stop, that doesn't when shouldn't
    before_destroy :check_scores
    
    
    def has_scores?
      #Determines whether item is on version associated with score. Returns true if so
      @versions = self.assessment_versions
      @versions.each do |v| 
          score = v.has_scores
          if score == true
              return true
          end
      end
      return false
    end
    private
    def check_scores
        if self.has_scores?
            self.errors.add(:base, "Can't modify item. Has associated scores.")
            return false
        end
    end
end
