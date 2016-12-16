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
require 'csv'


class Foi < ActiveRecord::Base
  self.table_name = 'forms_of_intention'
  belongs_to :student
  belongs_to :major

  scope :sorted, lambda {order(date_completing: :asc)}
  after_validation :check_major_id
  after_validation :check_eds_only

  validates :student_id,
    presence: {message: "could not be identified."}

  validates :date_completing,
  presence: {message: "is missing or incorrectly formatted. Example format: 2015-01-03 13:45:57"},
  uniqueness: { scope: :student_id,
    message: "May not have more than one FOI for a paticular student at a paticular time." }

  validates :new_form,
    :inclusion => { :in => [true, false],
        message: "Can't determine if this is a new form."
      }

  validates :seek_cert,
    :inclusion => { :in => [true, false],
        message: "Could not determine if student is seeking certification."
      }

  def check_major_id
    if self.seek_cert == true && self.major_id.blank?
      self.errors.add(:major_id, "is required and could not be determined.")
    end
  end

  def check_eds_only
    if self.seek_cert == false  && self.eds_only.nil?
      self.errors.add(:eds_only, "Could not determine if student is seeking EDS only")
    end
  end


  def self.import(file)
    #  file: type Rack::Test::UploadedFile
    # open the csv file, drop one row from the begining and then from the remainder open the first row
    # this returns an the resulting row inside of an array so pull it out using [0]

    if File.extname(file.original_filename) != ".xml"
      return {success: false, message: "File is not an .xml file."}
    end

    record_count = 0
    doc = File.open(file.path) { |f| Nokogiri::XML(f) }
    root = doc.root

    begin
      Foi.transaction do
        root.xpath('Response').each do |response|
          row = Hash.from_xml(response.to_s)["Response"]
          _import_foi(row)
          record_count += 1
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      raise "Error in record #{record_count + 1}: #{e.message}"
    end # begin

    return {success: true, message: nil, records: record_count }

  end

  def self._import_foi(row)
    # row: a hash of attributes
    # creates an foi record or raises an error if student can't be determined
    attrs = {}

    # these three attrs are processed the same.
    row_attrs = [
      {:name => "QID5",
        :slug => :new_form,
        :true => "New Form",
        :false => "Revision"
      },
      {:name => "QID3",
        :slug => :seek_cert,
        :true => "Yes",
        :false => "No"
      },
      {:name => "QID6",
        :slug => :eds_only,
        :true => "Yes",
        :false => "No"

      }
    ]

    row_attrs.each do |ra|
      col_name = ra[:name]
      raw_response = row[col_name]
      if raw_response == ra[:true]
        attrs[ra[:slug]] = true
      elsif raw_response == ra[:false]
        attrs[ra[:slug]] = false
      else
        attrs[ra[:slug]] = nil
      end
    end

    major_name = row["QID4"] # the raw name of the major from the fil
    major = Major.find_by(:name => major_name) # this could be nil!
    attrs[:major_id] = major.andand.id

    if major.nil? && attrs[:seek_cert]
      # if student is seeking cert, major should be Undecided, otherwise its nil
      attrs[:major_id] = Major.find_by(:name => "Undecided").id
    end



    #expected format: 9/2/16 9:25
    date_str = row["endDate"]  #date completing, from the csv

    begin
      attrs[:date_completing] = DateTime.strptime(date_str, "%Y-%m-%d %k:%M:%S")
    rescue ArgumentError, TypeError => e
      attrs[:date_completing] = nil
    end

    bnum = row["QID2_3"]
    attrs[:student_id] = Student.find_by({:Bnum => bnum}).andand.id

    Foi.create!(attrs)
  end
end
