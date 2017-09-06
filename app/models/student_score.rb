# == Schema Information
#
# Table name: student_scores
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  item_level_id :integer
#  scored_at     :datetime
#  created_at    :datetime
#  updated_at    :datetime
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
      [:moodle, :qualtrics]
    end

    def assessment
      assessment_item.assessment
    end

    def assessment_item
      item_level.assessment_item
    end

    private
    def self.find_headers_index(sheet, evidence)
      # finds the headers row of a sheet and returns the index
      # defined as the row where the first cell is "First name"
      # sheet: parsed roo sheet
      # evidence (string): the value in first cell of a row that defines the header

      sheet.each_with_index do |row, index|
        if row[0] == evidence
          return index + 1 # roo starts rows counting at 1 hence the add
        end
      end

      raise "headers row not found" # catch me!
    end

    def self.import_moodle(file, assessment)

    end # import_moodle

end
