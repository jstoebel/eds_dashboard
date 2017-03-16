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

    validates_presence_of :student_id, :item_level_id, :scored_at

    def self.import_moodle(file)
      # file: a spreadsheet of records from moodle
      # post:
        # records are imported
        # returns array of results for each record

      spreadsheet = Roo::Spreadsheet.open(file)
      sheet = spreadsheet.sheet(0)

      
      # assume the data is in the first sheet



    end
end
