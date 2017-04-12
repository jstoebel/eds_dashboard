# == Schema Information
#
# Table name: student_scores
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  item_level_id           :integer
#  scored_at               :datetime
#  created_at              :datetime
#  updated_at              :datetime
#  student_score_upload_id :integer
#

# a score on an assessment
class StudentScore < ApplicationRecord
    belongs_to :student
    belongs_to :item_level
    belongs_to :student_score_upload

    validates_presence_of :item_level_id, :scored_at

    validates :student_id,
      :presence => true,
      :uniqueness => {
        :message => "Duplicate record: student has already been scored for this item with this time stamp.",
        :scope => [:scored_at, :item_level_id]
      }

    def self.format_types
      return [:moodle, :qualtrics]
    end

    def self.import_setup(file, format, assessment)
      # dispatch file to right method here
        # file: the file to improt
        # format: which format the file is in (example: moodle)
        # assessment (AR object) the assessment this data is being imported for

      # self.send("import_#{format}", file, assessment)
      puts


    end

    def self.import_moodle(file, assessment)

    end # import_moodle

end
