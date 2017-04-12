class QualtricsProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(file, assessment)
    # Do something later

    # assumptions of all qualtrics assessments:
      # scores are provided in CSV format
      # the student's Bnum will not be provided
      # the field containing the student's name will vary by assessment.
        # but they will all contain the string "Student Full Name"
      # exactly one column will contain the string "Student Full Name"
      # the date recorded will be called RecordedDate. If there is more than
        # one such named column the first one will be used

    spreadsheet = Roo::Spreadsheet.open(file)
    sheet = spreadsheet.sheet(0)

    first_headers_row = sheet.row(1)
    second_headers_row = sheet.row(2)

    # use select to ensure that exactly one column will fit our criteria
    # use find_index to see what index that column is at

    name_col_count =  second_headers_row.select{|h| (h =~ /Student Full Name/).present? }.size

    if name_col_count != 1
      if name_col_count == 0
        problem = "Could not identify the column containing student names."
      else
        problem = "More than one column found that could contain student names. "
      end

      raise problem + 'Ensure exactly one column (and no more) contains the string "Student Full Name"'
    end

    name_col_i = second_headers_row.find_index { |i| /Student Full Name/ =~ i } # 0 based

    # RecordedDate
    recorded_at_col_i = first_headers_row.find_index { |i| i == "RecordedDate"}

    # array of arrays
      # each inner array: [assessment_item (AR object), col where it is found (0 based)]
    item_levels_mapping = second_headers_row
      .each_with_index
      .map{|item, i| [(AssessmentItem.find_by :name => item), i ]}
      .select{|item, i| item.present?}

    # find which row the data starts on

    student_count = 0
    confirmed_scores = 0
    temp_scores = 0
    strptime_pattern = "%Y-%m-%d %H:%M:%S"
    self.transaction do
      sheet.each.with_index(2) do |row|
        # starting at row 3. We can safly assume the first two rows are headers

        # test that the value in the first column should be a valid date. otherwise
        # its a junk row
        begin
          DateTime.strptime row[0], strptime_pattern
        rescue ArgumentError
          # not a row with data
          next
        end # error handle

        student_count += 1
        full_name = row[name_col_i]
        recorded_at = DateTime.strptime row[recorded_at_col_i], strptime_pattern

        qry = Student.with_name full_name
        possible_matches = Student.joins(:last_names).where(qry)

        item_levels_mapping.each do |item|

          descriptor = self.str_transform(row[item[1]])
          item_level = ItemLevel.find_by :descriptor => descriptor, :assessment_item_id => item[0].id

          binding.pry if item_level.nil?
          if possible_matches.size == 1
            begin
              self.create!({:student_id => possible_matches.first.id,
                :item_level_id => item_level.id,
                :scored_at => recorded_at
                })

            rescue => e
              binding.pry
              puts e
            end
            confirmed_scores += 1
          else
            StudentScoreTemp.create!({:full_name => full_name,
              :scored_at => recorded_at
            })
            temp_scores += 1
          end # if

        end # item_levels loop
      end # sheet loop
    end # transaction


    # TODO: create student_score_uploads
    return "Successfully imported #{student_count} #{'student'.pluralize student_count}, #{confirmed_scores} #{'matched score'.pluralize confirmed_scores}, and #{temp_scores} #{'unmatched score'.pluralize temp_scores}"

  end
end
