# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

=begin
    
represents a type of assessment, example Admission to Student Teaching.
specific versions of an assessment are modeled in AssessmentVersion
    
=end

class Assessment < ActiveRecord::Base

    ### ASSOCIATIONS ###
    has_many :assessment_versions, dependent: :destroy

    ### VALIDATIONS ###
    validates :name, :presence => true

    def versions
        return self.assessment_versions
    end

    def current_version
        return self.versions.order(:created_at => :asc).last
    end
            
    def has_scores
        vers = versions()    #should return result of versions
        scores = vers.select { |v| v.student_scores.present?}.size > 0 #is scores greater than 0?
        return scores    #a boolean value
    end
end