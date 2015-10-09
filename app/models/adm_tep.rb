class AdmTep < ActiveRecord::Base
  self.table_name = 'adm_tep'

  include ApplicationHelper

  after_save :change_status

  has_attached_file :letter, 
  :url => "/adm_tep/:altid/download",		#passes AltID 
  :path => ":rails_root/public/admission_letters/:bnum/:basename.:extension"

	validates_attachment_content_type :letter, :content_type => [ 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]

  belongs_to :program, {foreign_key: "Program_ProgCode"}
  belongs_to :student, {foreign_key: "Student_Bnum"}

  scope :admitted, lambda { where("TEPAdmit = ?", true)}

  scope :open, ->(bnum) {joins("LEFT JOIN prog_exits ON (adm_tep.Program_ProgCode = prog_exits.Program_ProgCode) and (adm_tep.Student_Bnum = prog_exits.Student_Bnum)").where("prog_exits.ExitID IS NULL AND adm_tep.TEPAdmit = 1 AND adm_tep.Student_Bnum = ?", bnum)}
  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}


	validate do |app|
		term = BannerTerm.find(app.BannerTerm_BannerTerm)
		next_term = BannerTerm.all.order(:BannerTerm).where("BannerTerm >?", app.BannerTerm_BannerTerm).first
		student = Student.find(app.Student_Bnum)
		app.errors.add(:base, "Please select a program.") if app.Program_ProgCode.blank?
		app.errors.add(:base, "Please select a student to apply.") if app.Student_Bnum.blank?
		app.errors.add(:base, "Admission date must be after term begins.") if app.TEPAdmitDate and app.TEPAdmitDate < term.StartDate
		app.errors.add(:base, "Admission date must be before next term begins.") if app.TEPAdmitDate and app.TEPAdmitDate >= next_term.StartDate
		app.errors.add(:base, "Admission date must be given.") if app.TEPAdmit and app.TEPAdmitDate.blank?
		app.errors.add(:base, "Student has not passed the Praxis I exam.") if app.TEPAdmit == true and not praxisI_pass(student)
		app.errors.add(:base, "Student does not have sufficent GPA to be admitted this term.") if app.TEPAdmit and app.GPA < 2.75 and app.GPA_last30 < 3.0
		app.errors.add(:base, "Student has not earned 30 credit hours.") if app.TEPAdmit and (app.EarnedCredits.nil? or app.EarnedCredits < 30)
		app.errors.add(:base, "Please attach an admission letter.") if (app.letter_file_name == nil and app.TEPAdmit != nil)
		#TODO must have completed EDS150 with B- or better to be admitted (expecting to change this to C by vote of TEC)
	end

  

  private
  def change_status
  	#if applcation was successful, change student's ProgStatus
  	if self.TEPAdmit
  		self.student.update_attributes :ProgStatus => "Candidate"
  	end
  end

end
