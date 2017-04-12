module StudentScoresHelper
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

  def self.str_transform(str)
    # transformations for some pesky characters read from csv files.
    # We are making these transformations to match what's in the database.

    new_str = str.dup
    replacements = [
      [/\u2019/, "'"]
    ]

    replacements.each {|replacement| new_str.gsub!(replacement[0], replacement[1])}
    return new_str

  end # csv_transform

end
