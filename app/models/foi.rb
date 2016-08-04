# == Schema Information
#
# Table name: forms_of_intention
#
#  id              :integer          not null, primary key
#  student_id      :integer          not null
#  date_completing :datetime
#  new_form        :boolean
#  major_id        :integer
#  seek_cert       :boolean
#  eds_only        :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

class Foi < ActiveRecord::Base
  self.table_name = 'forms_of_intention'
  belongs_to :student
  belongs_to :major

  def self.import(foi_file)
    foi_spreadsheet = open_spreadsheet(foi_file)
    header = foi_spreadsheet.row(2)
      (3..spreadsheet.last_row).each do |i|
        row = Hash [[header, spreadsheet.row(i)].transpose]
        CSV.foreach(foi_file.path, headers: true) do |row|
        Foi.create! row.to_hash.slice(*accessible_attributes)
        Foi.save
      end
    end
  end

  def self.open_spreadsheet(foi_file)
    case Foi_file.extname(foi_file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{foi_file.original_filename}"
    end
  end
  
end
