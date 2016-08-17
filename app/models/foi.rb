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
      a = ["Q1.2_3 - B#", "Q1.2_1 - First Name", "Q1.2_2 - Last Name"]
      b = [row[8][2], row[6][2], row[7][2]]
      c = [:Bnum, :FirstName, :LastName]
      attribute_array = Hash[a.zip b]
      attrs_array = Hash[c.zip a]
      # b_num = row[8][2]
      # first_name = row[6][2]
      # last_name = row[7][2]
      # attribute_array.push(["Q1.2_3 - B#", b_num], ["Q1.2_1 - First Name", first_name], ["Q1.2_2 - Last Name", last_name]).to_h
      
    
      #param_hash = [{:Bnum => "Q1.2_3 - B#", :FirstName => "Q1.2_1 - First Name", :LastName => "Q1.2_2 - Last Name"}]
      
      
      if Student.where(Bnum: row[8][2]) == 1
        stu_id = Student.find_by(Bnum: row[8][2]).id
        attribute_array.push(["student_id", stu_id])
        parameters = ActionController::Parameters.new(param_hash)
        Foi.create(parameters.permit(:student_id, :Bnum, :FirstName, :LastName))
      end 
      
    end
    
  end
  
  def self.find_stu(first, last)
    #method takes first and last name, returns list of possible matching students
    pos_matches = []
    #TODO there might other variations.
    Student.where( FirstName: "#{first}").to_a.each{|stu| pos_matches.push(stu)}
    (Student.where(LastName: "#{last}").to_a - pos_matches).each{|stu| pos_matches.push(stu)}
    return pos_matches
  end
  
  
end
