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

    def self.import_setup(file, format)
      # dispatch file to right method here
      self.send("import_#{format}", file)

    end

    def self.import_moodle(file)
      # file: a spreadsheet of records from moodle
      # post:
        # records are imported
        # returns array of results for each record

      spreadsheet = Roo::Spreadsheet.open(file)
      sheet = spreadsheet.sheet(0)  # assume the data is in the first sheet
      # lets not assume that we know where the headers row is

      headers_i = find_headers_index(sheet, "First name")
      headers = sheet.row( headers_i )


      self.transaction do

        (headers_i + 1..sheet.count).each do |row_i|

          begin
            stu = Student.find_by! :Bnum => sheet.cell('c', row_i)
          rescue
            name = ('a'..'b').map{ |ltr| sheet.cell(ltr, row_i) }.join(' ')
            raise "Could not find student at row #{row_i}: #{name}"
          end

          # index of each item_level definition
          item_levels_indecies = headers.each_index.select{|i| headers[i] == 'Definition'}
          item_levels_indecies.each do |level_i|
            begin
              level = ItemLevel.find_by! :descriptor =>  sheet.cell(row_i, level_i + 1)
              StudentScore.create!({:student_id => stu.id, :item_level_id => level.id})

            rescue
              byebug
              raise "Could not find descriptor at cell #{(65+level_i).chr}, #{row_i}: #{sheet.cell(row_i, level_i + 1)}"
            end # error handling

          end # item levels loop

        end # records loop

      end # transaction

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
