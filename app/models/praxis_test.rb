# == Schema Information
#
# Table name: praxis_tests
#
#  id               :integer          not null, primary key
#  TestCode         :string(45)       not null
#  TestName         :string(255)
#  CutScore         :integer
#  TestFamily       :string(1)
#  Sub1             :string(255)
#  Sub2             :string(255)
#  Sub3             :string(255)
#  Sub4             :string(255)
#  Sub5             :string(255)
#  Sub6             :string(255)
#  Sub7             :string(255)
#  Program_ProgCode :integer
#  CurrentTest      :boolean
#

# a type of praxis test
class PraxisTest < ApplicationRecord

  has_many :praxis_results
  has_many :praxis_result_temps
  belongs_to :program, :foreign_key => "Program_ProgCode"

  scope :current, lambda {where ("CurrentTest=1")}
  
  def family_roman
    # returns the roman numeral representation of the test family
    self.TestFamily.andand.to_i.andand.to_roman.andand.to_s
  end # family_roman
  
  def family_readable
    # returns a string of the test family. Exmple: Praxis I
    # if 
    numeral = self.family_roman
    numeral.nil? ? nil : "Praxis #{numeral}"
  end # family_readable
   
end
