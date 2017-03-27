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

      self.send("import_#{format}", file, assessment)

    end

    def self.import_moodle(file, assessment)
      # file: a spreadsheet of records from moodle
      # assessment (AR object) the assessment this data is being imported for
      # post:
        # records are imported
        # returns count of students and scores imported

      spreadsheet = Roo::Spreadsheet.open(file)
      sheet = spreadsheet.sheet(0)  # assume the data is in the first sheet
      # lets not assume that we know where the headers row is

      headers_i = find_headers_index(sheet, "First name")
      headers = sheet.row( headers_i )

      student_count = 0
      score_count = 0
      self.transaction do
        (headers_i + 1..sheet.count).each do |row_i|

          # identify the student
          begin
            stu = Student.find_by! :Bnum => sheet.cell(row_i, 3 )
          rescue
            name = (1..2).map{ |col| sheet.cell(row_i, col) }.join(' ')
            raise "Could not find student at row #{row_i}: #{name}"
          end

          begin
            time_graded_str = sheet.cell(row_i, headers.size) # example Tuesday, September 20, 2016, 10:37 AM
            time_graded = DateTime.strptime(time_graded_str, "%A, %B %e, %Y, %l:%M %P") # assumes blank padded date and hour
          rescue
            raise "Improper timestamp at row #{row_i}"
          end

          # index of each item_level definition
          item_levels_indecies = headers.each_index.select{|i| headers[i] == 'Definition'}
          item_levels_indecies.each do |level_i|

            # create student scores, assemble array of results for each
            begin
              level = assessment.item_levels.find_by! :descriptor =>  sheet.cell(row_i, level_i + 1)
            rescue
              raise "Improper descriptor at cell #{(65+level_i).chr}#{row_i}: #{sheet.cell(row_i, level_i + 1)}"
            end # error handling

            begin
              StudentScore.create!({:student_id => stu.id,
                :item_level_id => level.id,
                :scored_at => time_graded
              })
            rescue => e
              raise "Error at row #{row_i}: " + e.message
            end
            score_count += 1

          end # item levels loop

          student_count += 1
        end # records loop

      end # transaction
      return student_count, score_count
    end # import_moodle

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
