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

=begin
Represents a specific version of a paticular assessment
=end

class AssessmentVersion < ActiveRecord::Base

    ### ASSOCIATIONS ###
    belongs_to :assessment
    has_many :student_scores
    has_many :version_habtm_items
    has_many :assessment_items, :through => :version_habtm_items

    ### VALIDATIONS ###
    
    validates_presence_of :assessment_id
    #validates :version_num
    
    scope :sorted, lambda {order(:created_at => :asc)}
        
    def has_scores
        return self.student_scores.count > 0
    end
    
end
