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
    spreadsheet = CSV.read(foi_file.path)
    header = spreadsheet.row(2)
    CSV.foreach(foi_file.path, headers: true) do |row|
      #i = $.
      #attribute_array = [{:bnum => 'Q1.2_3 - B#', :FirstName => 'Q1.2_1 - First Name', :LastName => 'Q1.2_2 - Last Name'}]
      #attrs = [:Bnum, :FirstName, :LastName]
      # h = ["Q1.2_3 - B#", "Q1.2_1 - First Name", "Q1.2_2 - Last Name"]
      # csv_hash = attrs.zip(h).to_h
      csv_index = [row[8], row[20], row[23], row[21], row[22]]
      header_row = ["Recorded Date", "Q1.3 - Are you completing this form for the first time, or is this form a revision...", "Q3.1 - Which area do you wish to seek certification in?", "Q1.4 - Do you intend to seek teacher certification at Berea College?", "Q2.1 - Do you intend to seek an Education Studies degree without certification?"]
      table_attrs = [:date_completing, :new_form, :major_id, :seek_cert, :eds_only]
      index_to_header = Hash[header_row.zip csv_index]
      attrs_hash = Hash[table_attrs.zip header_row]

      attrs_hash[:seek_cert] = attrs_hash[:seek_cert] == "Yes"
      if attrs_hash[:new_form] == "New Form"
        "New Form" == true
      elsif attrs_hash[:new_form] == "Revision"
        "Revision" == false
      end
      # b_num = row[8][2]
      # first_name = row[6][2]
      # last_name = row[7][2]
      # attribute_array.push(["Q1.2_3 - B#", b_num], ["Q1.2_1 - First Name", first_name], ["Q1.2_2 - Last Name", last_name]).to_h
      
      #Foi.attributes = row.to_h.slice(:date_completing, :new_form, :major_id, :seek_cert, :eds_only)
    
      #param_hash = [{:Bnum => "Q1.2_3 - B#", :FirstName => "Q1.2_1 - First Name", :LastName => "Q1.2_2 - Last Name"}]
      bnum = "Q1.2_3 - B#"
      first_name = "Q1.2_1 - First Name"
      last_name = "Q1.2_2 - Last Name"
      major = "Q3.1 - Which area do you wish to seek certification in?"
      seek_cert = "Q1.4 - Do you intend to seek teacher certification at Berea College?"
      eds_only = "Q2.1 - Do you intend to seek an Education Studies degree without certification?"
      date_completing = "Recorded Date"
      new_form = "Q1.3 - Are you completing this form for the first time, or is this form a revision..."
      
      puts attrs_hash
      
      stu = Student.find_by({:Bnum => bnum})  # if no match is found, return nil
      major_id = Major.find_by({:major_id => major})
      

      # scenario 1, found a student from their B#
      if stu.present?
        # add the foi
        Foi.create!(:student_id => stu.id)
        
      else
        # scenario 2: get a perfect unique match from the first and last name
        stu = Student.find_by({:FirstName => first_name, :LastName => last_name})
        if stu.present?
          Foi.create!(attrs_hash)
        end
        
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
