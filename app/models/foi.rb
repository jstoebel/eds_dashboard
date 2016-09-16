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

  after_validation :check_major_id
  after_validation :check_eds_only

  validates :student_id,
    presence: {message: "Student could not be identified."}

  validates :date_completing,
  presence: {message: "Date completing is missing or incorrectly formatted. Example format: 01/01/2016 09:00:00 AM"},
  uniqueness: { scope: :student_id,
    message: "May not have more than one FOI for a paticular student at a paticular time." }

  validates :new_form,
    presence: {message: "Can't determine if this is a new form."}

  validates :seek_cert,
    :inclusion => { :in => [true, false],
        message: "Could not determine if student is seeking certification."
      }

  def check_major_id
    if self.seek_cert == true && self.major_id.blank?
      self.errors.add(:major_id, "Major could not be determined.")
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
    # TODO handle bad file type
    if File.extname(file.original_filename) != ".csv"
      return {success: false, message: "File is not a .csv file."}
    end

    headers = CSV.open(file.path, 'r').drop(1) { |csv| csv.first}[0]

    row_count = 0

    Foi.transaction do
      begin
        CSV.foreach(file.path) do |row|
          if $. > 2 # skipping first row
            _import_foi(Hash[headers.zip(row)])
            row_count += 1
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        return {success: false, message: "Error on line #{row_count + 2}: #{e.message}"}
      end

      return {success: true, message: nil, rows: row_count }

    end # transaction

  end

   # import
  #write a counter so that the first row is skipped on the first iteration

  def self._import_foi(row)
    # row: a hash of attributes
    # creates an foi record or raises an error if student can't be determined

    eds_only = row["Q2.1 - Do you intend to seek an Education Studies degree without certification?"].andand.downcase == "yes"
    seek_cert = row["Q1.4 - Do you intend to seek teacher certification at Berea College?"].andand.downcase == "yes"
    new_form = row["Q1.3 - Are you completing this form for the first time, or is this form a revision..."].andand.
      downcase == "new form"

    major_name = row["Q3.1 - Which area do you wish to seek certification in?"] # the raw name of the major from the fil
    major = Major.find_by(:name => major_name) # this could be nil!


    date_str = row["Recorded Date"]  #date completing, from the csv
    begin
      date = DateTime.strptime(date_str, "%m/%d/%Y %I:%M:%S %p")
    rescue ArgumentError, TypeError => e
      date = nil
    end

    bnum = row["Q1.2_3 - B#"]
    stu_id = Student.find_by({:Bnum => bnum}).andand.id

    attrs = {
        :student_id => stu_id,
        :date_completing => date,
        :new_form => new_form,
        :major_id => major.andand.id,
        :seek_cert => seek_cert,
        :eds_only => eds_only
    }

    Foi.create!(attrs)

  end
end
