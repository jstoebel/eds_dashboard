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
    has_many :assessment_items, :through => :version_habtm_items, dependent: :destroy

    ### VALIDATIONS ###
    validates :assessment_id, presence: {message: "Assessment must be selected."}

    scope :sorted, lambda { order( :assessment_id => :asc, :created_at => :asc) }
  
    def has_scores
        return self.student_scores.present?.size > 0
    end
    
    def version_num
      @versions = AssessmentVersion.where(:assessment_id => self.assessment_id)
      @versions.order(:created_at => :asc)
      version_num = @versions.find_index(self) + 1
      return version_num
    end
end
