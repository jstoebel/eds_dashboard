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
    has_many :assessment_versions

    ### VALIDATIONS ###
    validates :name, :presence => true

end
