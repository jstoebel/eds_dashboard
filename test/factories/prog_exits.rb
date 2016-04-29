# == Schema Information
#
# Table name: prog_exits
#
#  id                :integer          not null, primary key
#  student_id        :integer          not null
#  Program_ProgCode  :integer          not null
#  ExitCode_ExitCode :integer          not null
#  ExitTerm          :integer          not null
#  ExitDate          :datetime
#  GPA               :float(24)
#  GPA_last60        :float(24)
#  RecommendDate     :datetime
#  Details           :text
#
# Indexes
#
#  fk_Exit_ExitCode1_idx                                (ExitCode_ExitCode)
#  fk_Exit__Program_idx                                 (Program_ProgCode)
#  index_prog_exits_on_student_id_and_Program_ProgCode  (student_id,Program_ProgCode)
#  prog_exits_ExitTerm_fk                               (ExitTerm)
#

FactoryGirl.define do
  factory :prog_exit do

    #need to be entered by the caller
      #bnum
      #program
      # exit code
      ExitCode_ExitCode "1849"
      GPA 3.0
      GPA_last60 3.0
      ExitDate Date.today
      RecommendDate Date.today

  end 
end
