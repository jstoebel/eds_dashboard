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
    #CSV.foreach(file.path, headers: true) do |row|
    foi_csv = CSV.read(file.path)
    foi_csv[2..foi_csv.length].each do |x|
      attribute_array = [:bnum => "Q1.2_3 - B#"]
      foi_hash = x.header[foi_csv].to_h.slice(:bnum, :new_form) # exclude the price field
      student = Student.find_by(Bnum: attribute_array).id
      foi = Foi.where(student = foi_hash["Q1.2_3 - B#"])
      Foi.create
      foi.update_attributes(foi_hash)
    end
  end # end self.import(file)
  
end
