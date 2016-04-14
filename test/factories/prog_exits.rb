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