##
# processes spreadsheets from moodle in a background process
class MoodleProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(file_path, assessment)
    begin
      @report = StudentScoreUpload.create! source: :moodle
      @warnings = []
      @sheet = Roo::Spreadsheet.open(file_path).sheet(0)
      @headers_i = StudentScoresHelper.find_headers_index(@sheet, 'First name')
      @super_headers, @headers = ((@headers_i - 1)..@headers_i)
                                 .map { |i| @sheet.row(i) }

      @assessment = assessment
      @item_levels_indecies = @headers
                              .each_index
                              .select { |i| @headers[i] == 'Definition' }

      @student_count = 0
      @score_count = 0
      @warnings = []

      # iterate over each record
      StudentScore.transaction do
        (@headers_i + 1..@sheet.count).each do |row_i|
          _process_row row_i
        end
      end
      msg = "Successfully imported #{@student_count}" \
            " #{'student'.pluralize @student_count}" \
            " and #{@score_count} #{'matched score'.pluralize @score_count}."

      if @warnings.any?
        msg += " #{@warnings.size} #{'item'.pluralize @warnings.length} " \
        ' were not recognized and were skipped.'
      end
      @report.update_attributes! success: true, message: msg
    rescue Exception => e
      @report.update_attributes! success: false, message: e.message
    ensure
      FileUtils.rm file_path # clean up the file
    end
  end

  private

  ##
  # process a row
  # row_i (integer) the index of the row referenced
  def _process_row(row_i)
    @student = _id_student row_i
    @timestamp = _parse_timestamp row_i
    @item_levels_indecies.each do |level_i|
      _process_item level_i, row_i
    end
    @student_count += 1
  end

  ##
  # determine the student owning this record
  # row_i(int) index of the row
  def _id_student(row_i)
    return Student.find_by! Bnum: @sheet.row(row_i)
  rescue
    name = (0..1).map { |col| row[col] }.join(' ')
    raise "Could not find student at row #{row_i}: #{name}"
  end

  ##
  # determine the time of assessment for this record
  # row_i(int) index of the row
  # example input: Tuesday, September 20, 2016, 10:37 AM
  # assumes blank padded date and hour
  def _parse_timestamp(row_i)
    time_graded_str = @sheet
                      .cell(row_i, @headers.size)
    return DateTime.strptime(time_graded_str, '%A, %B %e, %Y, %l:%M %P')
  rescue
    raise "Improper timestamp at row #{row_i}"
  end

  ##
  # process an assessment item for a student
  def _process_item(level_i, row_i)
    # if you get multiple hits, filter by assessment_item
    level = _id_item_level level_i, row_i

    unless level.nil?
      begin
        StudentScore.create! student_id: @student.id, item_level_id: level.id,
                             scored_at: @timestamp,
                             student_score_upload_id: @report.id
        @score_count += 1
      rescue => e
        raise "Error at row #{row_i}: #{e.message}"
      end
    end
  end

  ## identify the item level
  # add a warning to @warnings if its not found
  # returns the level identified or nil if none found
  def _id_item_level(level_i, row_i)
    descriptor_stripped = @sheet
                          .cell(row_i, level_i + 1)
                          .gsub(/\s/, '')

    # some item levels share the same descriptor.
    # If we get more than one result, filter by assessment_item

    level_matches = @assessment
                    .item_levels
                    .where descriptor_stripped: descriptor_stripped

    assessment_item = AssessmentItem.find_by_slug @super_headers[level_i - 1]

    # if you get multiple hits, filter by assessment_item
    level = level_matches.size > 1 ?
      level_matches.find_by_assessment_item_id(assessment_item.andand.id) :
      level_matches.first

    @warnings << "Descriptor not found: #{@sheet.cell(row_i, level_i + 1)}" if level.nil?
    level
  end

end
