# == Schema Information
#
# Table name: assessment_versions
#
#  id            :integer          not null, primary key
#  assessment_id :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

=begin
Represents a specific version of a paticular assessment
=end

class AssessmentVersion < ActiveRecord::Base
    before_destroy :can_destroy

    ### ASSOCIATIONS ###
    belongs_to :assessment
    has_many :student_scores
    has_many :version_habtm_items
    has_many :assessment_items, :through => :version_habtm_items, dependent: :destroy

    ### VALIDATIONS ###
    validates :assessment_id, presence: {message: "Assessment must be selected."}

    scope :sorted, lambda {order(:assessment_id => :asc, :created_at => :asc)}

    def repr
        return "new version" if self.new_record?
        return "#{self.assessment.name}-#{self.version_num}"
    end

    def has_scores
        #returns true if there are scores in the array
        return self.student_scores.present?
    end

    def version_num
      @versions = AssessmentVersion.where(:assessment_id => self.assessment_id)
      @versions.order(:created_at => :asc)
      version_num = @versions.find_index(self) + 1
      return version_num
    end

    def can_destroy
        #returns false if has scores and cannot delete
        #returns true if does not have scores and can delete
        if self.has_scores == true
            return false
        else
            return true
        end
    end
end
