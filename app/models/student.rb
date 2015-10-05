class Student < ActiveRecord::Base

	has_many :praxis_results, {:foreign_key => 'Bnum'}
	has_many :issues, {:foreign_key => 'students_Bnum'}

	has_many :adm_tep, {:foreign_key => 'Student_Bnum'}
	has_many :programs, {:foreign_key => 'Student_Bnum', through: :adm_tep}

	has_many :adm_st, {:foreign_key => 'Student_Bnum'}
	has_many :prog_exits, {:foreign_key => 'Student_Bnum'}
	has_many :clinical_assignments, {:foreign_key => 'Student_Bnum'}

	scope :by_last, lambda {order(LastName: :asc)}
	scope :current, lambda { where("ProgStatus in (?) and EnrollmentStatus='Active Student'", ['Candidate', 'Prospective'])}		#TODO also need to know if student is activly enrolled (see banner)
	scope :candidates, lambda {where("ProgStatus='Candidate' and EnrollmentStatus='Active Student'")}
	scope :from_alt_id, ->(alt_id) {where("AltID = ?", alt_id).first}		#finds a student based on AltID

end
