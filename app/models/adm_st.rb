class AdmSt < ActiveRecord::Base
  self.table_name = 'adm_st'
  include ApplicationHelper

  has_attached_file :letter, 
	  :url => "/adm_st/:altid/download",		#passes AltID 
	  :path => ":rails_root/public/:bnum/adm_st_letters/:basename.:extension"	#changed path from /adm_st_letters/:bnum

	validates_attachment_content_type :letter, :content_type => [ 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]

  belongs_to :student, foreign_key: "Student_Bnum"

  validate do |app|
	term = BannerTerm.find(app.BannerTerm_BannerTerm)	#current term
	next_term = BannerTerm.all.order(:BannerTerm).where("BannerTerm >?", app.BannerTerm_BannerTerm).first		#next term in sequence
	student = Student.find(app.Student_Bnum)
	app.errors.add(:base, "Please select a student to apply.") if app.Student_Bnum.blank?
	app.errors.add(:base, "Admission date must be after term begins.") if app.STAdmitDate and app.STAdmitDate < term.StartDate
	app.errors.add(:base, "Admission date must be before next term begins.") if app.STAdmitDate and app.STAdmitDate >= next_term.StartDate
	app.errors.add(:base, "Admission date must be given.") if app.STAdmitted and app.STAdmitDate.blank?
	app.errors.add(:base, "Please attach an admission letter.") if (app.letter_file_name == nil and app.STAdmitted != nil)
  end
  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}
end
