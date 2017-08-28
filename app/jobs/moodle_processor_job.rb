class MoodleProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(file_path, assessment)
    # file_path: a path to a spreadsheet of records from moodle
    # assessment (AR object) the assessment this data is being imported for
    # post:
      # records are imported
      # returns count of students and scores imported

    # assumptions
      # need to remove attendes that were not scored (such as faculty and staff)

    report = StudentScoreUpload.create! source: :moodle
    @warnings = []
    begin
      spreadsheet = Roo::Spreadsheet.open(file_path)
      sheet = spreadsheet.sheet(0)  # assume the data is in the first sheet
      # lets not assume that we know where the headers row is

      headers_i = StudentScoresHelper.find_headers_index(sheet, "First name")
      headers = sheet.row(headers_i)
      super_headers = sheet.row(headers_i - 1)

      student_count = 0
      score_count = 0
      StudentScore.transaction do
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
   
            descriptor_stripped = sheet
                                  .cell(row_i, level_i + 1)
                                  .gsub(/\s/, '')

            # some item levels share the same descriptor. 
            # If we get more than one result, filter by assessment_item

            level_matches = assessment
                    .item_levels
                    .where descriptor_stripped: descriptor_stripped


            assessment_item = AssessmentItem.find_by_slug super_headers[level_i - 1]

            level = level_matches.size > 1 ?
              level_matches.find_by_assessment_item_id(assessment_item.andand.id) :
              level_matches.first

            if level.nil?
              # could not find the item level. Just skip
              @warnings << "Descriptor not found: #{sheet.cell(row_i, level_i + 1)}"
              next
            end

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

      msg = "Successfully imported #{student_count} #{'student'.pluralize student_count}" \
            " and #{score_count} #{'matched score'.pluralize score_count}."
      if @warnings.any?
        msg += " #{@warnings.size} #{'item'.pluralize @warnings.length} were not" \
        "recognized and were skipped."
      end
      report.update_attributes!({:success => true, :message => msg})
    rescue => e
      report.update_attributes!({:success => false, :message => e.message})
    ensure
      FileUtils.rm file_path # clean up the file
    end # exception handle

  end # process

  private

  def _index_to_excel idx
    # convert an excel base 0 index to excel column
    # example
    # 0 -> A
    # 26 -> AA

    # idx(integer) the column base 0 index to convert

    div = idx + 1
    result = ''
    temp = 0
    while div > 0
      mod = (div - 1) % 26
      result = (65 + mod).chr + result
      div = ((div - mod) / 26).to_i
    end
    result

  end

end
