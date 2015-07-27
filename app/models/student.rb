class Student < ActiveRecord::Base

	has_many :praxis_results, {:foreign_key => 'Bnum'}
	has_many :issues, {:foreign_key => 'students_Bnum'}

	scope :current, lambda { where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])}		#also need to know if student is activly enrolled
	scope :by_last, lambda {order(LastName: :asc)}

end
