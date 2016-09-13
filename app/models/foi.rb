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

  validates_presence_of :student_id, :date_completing, :new_form, :major_id, :seek_cert, :eds_only
  
  def self.import(file)
     # open the csv file, drop one row from the begining and then from the remainder open the first row
    # this returns an the resulting row inside of an array so pull it out using [0]
    headers = CSV.open(file, 'r').drop(1) { |csv| csv.first}[0]
  
    row_count = 0
    Foi.transaction do
      
      begin
      
        CSV.foreach(file) do |row|
          if $. > 2 # skipping first row 
            row_num = $.
            _import_foi(Hash[headers.zip(row)])
            row_count += 1
          end
        end
        
      rescue ActiveRecord::RecordInvalid => e
        return {success: false, message: "Error on line #{row_num}: #{e.message}"}
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
    rescue ArgumentError => e
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
