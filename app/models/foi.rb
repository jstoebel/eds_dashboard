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

  require 'csv'
  include CSV
  
  def self.import(foi_file)
    file_path = "foi_file_test.csv"
    
    CSV.foreach(file_path) do |row|
      i = $.
      attribute_array = [{:bnum => 'Q1.2_3 - B#', :FirstName => 'Q1.2_1 - First Name', :LastName => 'Q1.2_2 - Last Name'}]
      if i == 1
        header = row.to_h.slice(attribute_array)
      elsif i > 1
        attribute_array.push
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
