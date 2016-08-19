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

 
  
  def self.import(foi_file)
    CSV.foreach(foi_file.path, headers: true) do |row|
      header_row = [row["Recorded Date"], row["Q1.3 - Are you completing this form for the first time, or is this form a revision..."], row["Q3.1 - Which area do you wish to seek certification in?"], row["Q1.4 - Do you intend to seek teacher certification at Berea College?"], row["Q2.1 - Do you intend to seek an Education Studies degree without certification?"], row["Q1.2_3 - B#"]]
      table_attrs = [:date_completing, :new_form, :major_id, :seek_cert, :eds_only]
      stu_headers = [row["Q1.2_1 - First Name"], row["Q1.2_2 - Last Name"], row["Q1.2_3 - B#"]]
      stu_attrs = [:FirstName, :LastName, :Bnum]
      attrs_hash = Hash[table_attrs.zip header_row]
      stu_attrs = Hash[stu_attrs.zip stu_headers]

      attrs_hash[:seek_cert] = attrs_hash[:seek_cert] == "Yes"
      
      attrs_hash[:eds_only] = attrs_hash[:eds_only] == "Yes"
      
      attrs_hash[:new_form] = attrs_hash[:new_form] == "New Form"
 
      bnum = stu_attrs[:Bnum]
      first_name = stu_attrs[:FirstName]
      last_name = stu_attrs[:LastName]
      major = stu_attrs[:major_id]
      seek_cert = attrs_hash[:seek_cert]
      eds_only = attrs_hash[:eds_only]
      date_completing = attrs_hash[:date_completing]
      new_form = attrs_hash[:new_form]
      
      
      
      stu = Student.find_by({:Bnum => bnum})  # if no match is found, return nil
      major_id = Major.find_by(major)
      
      foi_attrs = [major_id, seek_cert, eds_only, date_completing, new_form]
      # scenario 1, found a student from their B#
      if stu.present?
        # add the foi
        Foi.create!({:student_id => stu.id}, foi_attrs)
        
      else
        # scenario 2: get a perfect unique match from the first and last name
        stu = Student.find_by({:FirstName => first_name, :LastName => last_name})
        if stu.present?
          Foi.create!
        end
        
      end
 
      
    end
    
  end

  
end
