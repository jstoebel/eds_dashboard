class AdmTep < ActiveRecord::Base
  self.table_name = 'adm_tep'

  include ApplicationHelper

  has_attached_file :letter, 
  :url => "/adm_tep_letters/:id/:basename.:extension",
  :path => ":rails_root/app/assets/student_files/:bnum/admission_letters/:term/:basename.:extension"

	validates_attachment_content_type :letter, :content_type => [ 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]

  has_one :program
  belongs_to :student, foreign_key: "Student_Bnum"

	validate do |app|
		term = BannerTerm.find(app.BannerTerm_BannerTerm)
		student = Student.find(app.Student_Bnum)
		app.errors.add(:base, "Please select a student to apply.") if app.Student_Bnum.blank?
		app.errors.add(:base, "Please select a program.") if app.Program_ProgCode.blank?
		app.errors.add(:base, "Admission date must be inside term.") if app.TEPAdmitDate and (app.TEPAdmitDate < term.StartDate or app.TEPAdmitDate > term.EndDate)
		app.errors.add(:base, "Admission date must be given.") if app.TEPAdmit and app.TEPAdmitDate.blank?
		app.errors.add(:base, "Student has not passed the Praxis I exam.") if app.TEPAdmit == true and not praxisI_pass(student)
		app.errors.add(:base, "Student does not have sufficent GPA to be admitted this term.") if app.TEPAdmit and app.GPA < 2.75 and app.GPA_last30 < 3.0
		app.errors.add(:base, "Student has not earned 30 credit hours.") if app.TEPAdmit and (app.EarnedCredits.nil? or app.EarnedCredits < 30)
	end

  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}


end
