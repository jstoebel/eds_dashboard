# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)      not null
#

=begin

represents a type of assessment, example Admission to Student Teaching.
specific versions of an assessment are modeled in AssessmentVersion
q
=end

class Assessment < ApplicationRecord 

    ### ASSOCIATIONS ###
    has_many :assessment_items
    has_many :item_levels, :through => :assessment_items
    has_many :student_scores, :through => :item_levels

    ### VALIDATIONS ###
    validates :name, :presence => true

    def repr
        return self.name
    end

end
