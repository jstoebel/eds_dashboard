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
  
    CSV.foreach(foi_file.path) do |row|
      #i = $.
      #attribute_array = [{:bnum => 'Q1.2_3 - B#', :FirstName => 'Q1.2_1 - First Name', :LastName => 'Q1.2_2 - Last Name'}]
      #attrs = [:Bnum, :FirstName, :LastName]
      # h = ["Q1.2_3 - B#", "Q1.2_1 - First Name", "Q1.2_2 - Last Name"]
      # csv_hash = attrs.zip(h).to_h

      header_row = ["Q1.4 - Do you intend to seek teacher certification at Berea College?"]
      column = [row[21]]
      table_attrs = [:seek_cert]
    
      header_to_column = Hash[header_row.zip column]
      attrs_hash = Hash[table_attrs.zip header_row]

      attrs_hash[:seek_cert] = attrs_hash[:seek_cert] == "Yes"
      # b_num = row[8][2]
      # first_name = row[6][2]
      # last_name = row[7][2]
      # attribute_array.push(["Q1.2_3 - B#", b_num], ["Q1.2_1 - First Name", first_name], ["Q1.2_2 - Last Name", last_name]).to_h
      
    
      #param_hash = [{:Bnum => "Q1.2_3 - B#", :FirstName => "Q1.2_1 - First Name", :LastName => "Q1.2_2 - Last Name"}]
      puts row[16]
      
      bnum = row[16]
      first_name = row[14]
      last_name = row[15]
      major_id = Major.find_by ...
      seek_cert = ???
      eds_only = ???
      date_completing = ???
      new_form = ???
      
      stu = Student.find_by({:Bnum => bnum})  # if no match is found, return nil

      # scenario 1, found a student from their B#
      if stu.present?
        # add the foi
        Foi.create!(:student_id => stu.id)
      else
        
        # scenario 2: get a perfect unique match from the first and last name
        stu = Student.find_by({:FirstName => first_name, :LastName => last_name})
        if stu.present?
          Foi.create!
        end
        
      end
        
      
      
      # scenario 
      
      if Student.where(Bnum: row[16]).size == 1
        stu_id = Student.find_by(Bnum: row[16]).id
        attrs_hash[:student_id] = stu_id
        Foi.create!
      end 
      
    end
    
  end
  
  # def self.find_stu(first, last)
  #   #method takes first and last name, returns list of possible matching students
  #   pos_matches = []
  #   #TODO there might other variations.
  #   Student.where( FirstName: "#{first}").to_a.each{|stu| pos_matches.push(stu)}
  #   (Student.where(LastName: "#{last}").to_a - pos_matches).each{|stu| pos_matches.push(stu)}
  #   return pos_matches
  # end
  
  
end
