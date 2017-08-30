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
      [:moodle, :qualtrics]
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

    def self.import_qualtrics(file, assessment)
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
        # each inner array: [assessment_item (AR object), col index (0 based)]
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
            item_level = ItemLevel.find_by :descriptor => row[item[1]]

            binding.pry if item_level.nil?
            if possible_matches == 1
              self.create!({:student_id => possible_matches.first.id,
                :item_level_id => item_level.id,
                :scored_at => recorded_at
              })
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
      return "Successfully imported #{pluralize student_count, 'student'}, #{pluralize confirmed_scores 'matched score'}, #{pluralize temp_scores, 'unmatched score'}"

    end # self.import_qualtrics

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
