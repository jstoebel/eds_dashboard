class Student < ActiveRecord::Base


	scope :current, lambda { where("ProgStatus in (?)", ['Candidate', 'Prospective'])}		#also need to know if student is activly enrolled
end
