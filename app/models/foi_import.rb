class FoiImport < ActiveModel::Foi
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  belongs_to :foi

  attr_accessor :foi_file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_fois.map(&:valid?).all?
      imported_fois.each(&:save!)
      true
    else
      imported_foiseach_with_index do |foi, index|
        foi.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_fois
    @imported_fois ||= load_imported_fois
  end

  def load_imported_fois
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      foi = Foi.find_by_id(row["id"]) || Foi.new
      foi.attributes = row.to_hash.slice(*Foi.accessible_attributes)
      foi
    end
  end

  def open_spreadsheet
    case FoiFile.extname(foi_file.original_filename)
    when ".csv" then Csv.new(foi_file.path, nil, :ignore)
    when ".xls" then Excel.new(foi_file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(foi_file.path, nil, :ignore)
    else raise "Unknown file type: #{foi_file.original_filename}"
    end
  end
end