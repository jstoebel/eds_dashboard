class MoodleProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(file, assessment)
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
    
    # TODO: create student_score_uploads
    return student_count, score_count
  end
end
