class AdmSt < ActiveRecord::Base
  self.table_name = 'adm_st'
  include ApplicationHelper

	attr_accessor :skip_val_letter

  has_attached_file :letter, 
	  :url => "/adm_st/:id/download",		
	  :path => ":rails_root/public/:bnum/adm_st_letters/:basename.:extension"	#changed path from /adm_st_letters/:bnum
  
  belongs_to :student, foreign_key: "Student_Bnum"
  belongs_to :banner_term, foreign_key: "BannerTerm_BannerTerm"

	validates_attachment_content_type :letter, :content_type => [ 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]
	
	validate :validate_letter, unless: :skip_val_letter
	scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}


  validate :if => :check_fks do |app|
		# term = BannerTerm.find(app.BannerTerm_BannerTerm)	#current term
		next_term = BannerTerm.all.order(:BannerTerm).where("BannerTerm >?", app.BannerTerm_BannerTerm).first		#next term in sequence
		student = Student.find(app.Student_Bnum)
		app.errors.add(:STAdmitDate, "Admission date must be after term begins.") if app.STAdmitDate and app.STAdmitDate < app.banner_term.StartDate
		app.errors.add(:STAdmitDate, "Admission date may not be before next term begins.") if app.STAdmitDate and app.STAdmitDate >= next_term.StartDate
		app.errors.add(:STAdmitDate, "Admission date must be given.") if app.STAdmitted and app.STAdmitDate.blank?
    
    accepted_apps = AdmSt.where(Student_Bnum: app.Student_Bnum).where(BannerTerm_BannerTerm: app.BannerTerm_BannerTerm).where("STAdmitted = 1 or STAdmitted IS NULL")

    if accepted_apps.size > 0 and app.new_record?
      app.errors.add(:base, "Student has already been admitted or has an open applicaiton in this term.")
    end

	end

	def validate_letter
		#validates presence of a letter.
		if (self.letter_file_name == nil and self.STAdmitted != nil)
			self.errors.add(:base, "Please attach an admission letter.")
		end 
	end


  private

  def check_fks
    #validate the foreign keys and return true if all are good.
    self.errors.add(:Student_Bnum, "No student selected.") unless self.Student_Bnum
    self.errors.add(:BannerTerm_BannerTerm, "No term could be determined.") unless self.BannerTerm_BannerTerm

    if self.errors.size == 0

      return true
    else
      return false
    end
  	
  end

end
