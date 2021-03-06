# == Schema Information
#
# Table name: transcript
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  crn               :string(45)       not null
#  course_code       :string(45)       not null
#  course_section    :string(255)
#  course_name       :string(100)
#  term_taken        :integer          not null
#  grade_pt          :float(24)
#  grade_ltr         :string(2)
#  quality_points    :float(24)
#  credits_attempted :float(24)
#  credits_earned    :float(24)
#  reg_status        :string(45)
#  instructors       :text(65535)
#  gpa_include       :boolean          not null
#

class Transcript < ApplicationRecord
  self.table_name = 'transcript'


    #~~~CLASS VARIABLES AND METHODS~~~#
    # berea college mapping of grades to grade points
    LTG = {
        "A+" => 4.0,
        "A" => 4.0,
        "A-" => 3.7,
        "B+" => 3.3,
        "B"=> 3.0,
        "B-" => 2.7,
        "C+" => 2.3,
        "C"=> 2.0,
        "C-" => 1.7,
        "D+" => 1.3,
        "D"=> 1.0,
        "D-" => 0.7,
        "F"=> 0.0
    }

    def self.l_to_g(ltr)
        #returns the grade_pt coorsponding to ltr
        return LTG[ltr]
    end

    def self.g_to_l(grade_pt)
        #returns the letter grade coorsponding to grade_pt
        # keys are readin in order from top to bottom with newer keys replacing
        # old. In this case, 4.0 is mapped to "A" not "A+"
        return LTG.invert[grade_pt.to_f]
    end

    def self.standard_grades
      # only standard letter grades (not things like I)
      return LTG.keys
    end

    def self.batch_upsert(hashes)
        # bulk upserts transcript records
        # hashes: array of hashes each containing params
        # returns success status and success/error message.

        begin
            Transcript.transaction do
                hashes.each do |stu_hash|
                    Transcript.find_or_create_by! stu_hash
                end #loop
            end #transaction
        rescue ActiveRecord::RecordInvalid => msg
            #some record couldn't be saved
            return {:success => false, :msg => msg.to_s}
        end #exception handle
        return {:success => true, :msg => "Successfully upserted #{hashes.size} records."}
    end

    #~~~HOOKS~~~#
    before_save :set_quality_points


    #~~~ASSOCIATIONS~~~#
  belongs_to :student
  belongs_to :banner_term, :foreign_key => "term_taken"
  has_many :clinical_assignments

    #~~~SCOPES~~~#
  scope :in_term, ->(term_object) { where(term_taken: term_object.BannerTerm)}


    #~~~VALIDATIONS~~~#

    validates_presence_of :student_id, :crn, :course_code, :term_taken

    validates :crn, uniqueness: { scope: [:student_id, :term_taken],
        message: "student may not have duplicates of the same course in the same term." }

    def set_quality_points
        # determine quality points for a course grade
        if self.grade_pt.present? && self.credits_earned.present?
            #sets quality_points for a record
            if self.grade_pt_changed? || self.credits_earned_changed?
                self.quality_points = self.grade_pt * self.credits_earned
            end
        end
    end


    #~~~INSTANCE METHODS ~~~#

    def inst_bnums
      # returns an array of instructor B#s for this course
      profs_raw = self.instructors.andand.split ";"
      if profs_raw.present?
        return profs_raw.map{|r| r.match(/\{(.+)\}/)[1]}
      else
        return []
      end
    end

end
