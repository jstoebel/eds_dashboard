class Foi < ActiveRecord::Base
  self.table_name = 'forms_of_intention'
  belongs_to :student
  belongs_to :major

end
