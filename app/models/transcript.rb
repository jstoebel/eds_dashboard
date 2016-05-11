# == Schema Information
#
# Table name: transcript
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  crn               :string(45)       not null
#  course_code       :string(45)       not null
#  course_name       :string(100)
#  term_taken        :integer          not null
#  grade_pt          :float(24)
#  grade_ltr         :string(2)
#  quality_points    :float(24)
#  credits_attempted :float(24)
#  credits_earned    :float(24)
#  reg_status        :string(45)
#  Inst_bnum         :string(45)
#  gpa_include       :boolean          not null
#

class Transcript < ActiveRecord::Base
	self.table_name = 'transcript'

    #~~~HOOKS~~~#
    before_save :set_quality_points


    #~~~ASSOCIATIONS~~~#
	belongs_to :student
    belongs_to :banner_term, :foreign_key => "term_taken"



    #~~~SCOPES~~~#
	scope :in_term, ->(term_object) { where(term_taken: term_object.BannerTerm)}


    #~~~VALIDATIONS~~~# 

    def set_quality_points

        if self.grade_pt.present? && self.credits_earned.present? 
            #sets quality_points for a record
            if self.grade_pt_changed? || self.credits_earned_changed?
                self.quality_points = self.grade_pt * self.credits_earned
            end
        end
    end
    
end
