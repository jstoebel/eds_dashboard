class MajorProgram < ActiveRecord::Base
  self.table_name = "major_programs"

  belongs_to :major
  belongs_to :program
end
