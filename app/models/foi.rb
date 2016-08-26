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

 
  
  def self.import(file)
    
    CSV.foreach(file.path, headers: true) do |row|
      
      begin
        _import_foi(row)
      rescue ActiveRecord::RecordInvalid => e
        _create_temp(row)
      end
      
      
  
      
      
      # attrs = {
      #   # csv_header_name => AR object attr
      #   :eds_only => "Q2.1 - Do you intend to seek an Education Studies degree without certification?",
      #   :seek_cerk => "Q1.4 - Do you intend to seek teacher certification at Berea College?",
      #   :new_form => "Q1.3 - Are you completing this form for the first time, or is this form a revision...",
      #   :major_id => "Q3.1 - Which area do you wish to seek certification in?",
      #   :date_completing => "Recorded Date",
      #   :Bnum => "Q1.2_3 - B#",
      #   :FirstName => "Q1.2_1 - First Name",
      #   :LastName => "Q1.2_2 - Last Name"
      # }
      
      
      # header_row = [row["Recorded Date"], row["Q1.3 - Are you completing this form for the first time, or is this form a revision..."], row["Q3.1 - Which area do you wish to seek certification in?"], row["Q1.4 - Do you intend to seek teacher certification at Berea College?"], row["Q2.1 - Do you intend to seek an Education Studies degree without certification?"], row["Q1.2_3 - B#"]]
      # table_attrs = [:date_completing, :new_form, :major_id, :seek_cert, :eds_only]
      # stu_headers = [row["Q1.2_1 - First Name"], row["Q1.2_2 - Last Name"], row["Q1.2_3 - B#"]]
      # stu_attrs = [:FirstName, :LastName, :Bnum]
      # attrs_hash = Hash[table_attrs.zip header_row]
      # stu_attrs = Hash[stu_attrs.zip stu_headers]

      # attrs_hash[:seek_cert] = attrs_hash[:seek_cert] == "Yes"
      
      # attrs_hash[:eds_only] = attrs_hash[:eds_only] == "Yes"
      
      # attrs_hash[:new_form] = attrs_hash[:new_form] == "New Form"
 
      # bnum = stu_attrs[:Bnum]
      # first_name = stu_attrs[:FirstName]
      # last_name = stu_attrs[:LastName]
      # major = stu_attrs[:major_id]
      # seek_cert = attrs_hash[:seek_cert]
      # eds_only = attrs_hash[:eds_only]
      # date_completing = attrs_hash[:date_completing]
      # new_form = attrs_hash[:new_form]
      
      
      
      # stu = Student.find_by({:Bnum => bnum})  # if no match is found, return nil
      # major_id = Major.find_by(major.id)
      
      # foi_attrs = [major_id, seek_cert, eds_only, date_completing, new_form]
      # # scenario 1, found a student from their B#
      
      # if stu.present?
      #   # add the foi
      #   Foi.create!({:student_id => stu.id}, foi_attrs)
        
      # else
      #   # scenario 2: get a perfect unique match from the first and last name
      #   stu = Student.find_by({:FirstName => first_name, :LastName => last_name})
      #   if stu.present?
      #     Foi.create!({:student_id => stu.id}, foi_attrs)
      #   end
        
      # end
 

    end
  
  end # import
  
  private
  
  def _import_foi(row)
    # row: a csv row
    # creates an foi record or raises an error if student can't be determined 
    eds_only = row["Q2.1 - Do you intend to seek an Education Studies degree without certification?"].downcase == "yes"
    seek_cert = row["Q1.4 - Do you intend to seek teacher certification at Berea College?"].downcase == "yes"
    new_form = row["Q1.3 - Are you completing this form for the first time, or is this form a revision..."].downcase == "new form"
  
    major_name = row["Q3.1 - Which area do you wish to seek certification in?"] # the raw name of the major from the file
    major = Major.find_by major_name
      
    date_str = row["Recorded Date"]  #date completing, from the csv
    date = DateTime.strptime(date_str, "%m/%d/%Y")
      
    bnum = row["Q1.2_3 - B#"]
    if bnum.present?
      
      stu_id = Student.find_by({:Bnum => bnum}).id
        
    else 
        # find by first/last
      first_name = row["Q1.2_1 - First Name"]
      last_name = row["Q1.2_2 - Last Name"]
      soft_matches = Student.where({:FirstName => first_name, :LastName => last_name})
      if soft_matches.size == 1
        stu_id = soft_matches.first.id
      end
        
    end
      
    attrs = {
        :student_id => stu_id,
        :date_completing => date,
        :new_form => new_form,
        :major_id => major.id,
        :seek_cert => seek_cert,
        :eds_ony => eds_only
      }
      
    Foi.create!(attrs)
  
  end
    
  def _create_temp(row)
    # create a temporary record for user to match up later
    temp_foi.create!(attrs)
  
  end

end
