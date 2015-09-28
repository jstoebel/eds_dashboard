class Student < ActiveRecord::Base

	has_many :praxis_results, {:foreign_key => 'Bnum'}
	has_many :issues, {:foreign_key => 'students_Bnum'}
	has_many :adm_tep, {:foreign_key => 'Student_Bnum'}
	has_many :adm_st, {:foreign_key => 'Student_Bnum'}
	has_many :prog_exits, {:foreign_key => 'Student_Bnum'}
	has_many :clinical_assignments, {:foreign_key => 'Bnum'}

	scope :current, lambda { where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])}		#TODO also need to know if student is activly enrolled (see banner)
	scope :by_last, lambda {order(LastName: :asc)}

end
