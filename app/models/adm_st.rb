# == Schema Information
#
# Table name: adm_st
#
#  student_id            :integer          not null
#  id                    :integer          not null, primary key
#  BannerTerm_BannerTerm :integer
#  Attempt               :integer          not null
#  OverallGPA            :float(24)
#  CoreGPA               :float(24)
#  STAdmitted            :boolean
#  STAdmitDate           :datetime
#  STTerm                :integer
#  Notes                 :text
#  background_check      :boolean
#  beh_train             :boolean
#  conf_train            :boolean
#  kfets_in              :boolean
#  created_at            :datetime
#  updated_at            :datetime
#  student_file_id       :integer
#
# Indexes
#
#  adm_st_student_file_id_fk  (student_file_id)
#  adm_st_student_id_fk       (student_id)
#  fk_AdmST_BannerTerm1_idx   (BannerTerm_BannerTerm)
#

class AdmSt < ActiveRecord::Base
  self.table_name = 'adm_st'
  include ApplicationHelper

	attr_accessor :skip_val_letter
  
  belongs_to :student
  belongs_to :banner_term, foreign_key: "BannerTerm_BannerTerm"
  belongs_to :student_file

	scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}


  validate :if => :check_fks do |app|
		# term = BannerTerm.find(app.BannerTerm_BannerTerm)	#current term
		next_term = BannerTerm.all.order(:BannerTerm).where("BannerTerm >?", app.BannerTerm_BannerTerm).first		#next term in sequence
		student = Student.find(app.student_id)
		app.errors.add(:STAdmitDate, "Admission date must be after term begins.") if app.STAdmitDate and app.STAdmitDate < app.banner_term.StartDate
		app.errors.add(:STAdmitDate, "Admission date may not be before next term begins.") if app.STAdmitDate and app.STAdmitDate >= next_term.StartDate
		app.errors.add(:STAdmitDate, "Admission date must be given.") if app.STAdmitted and app.STAdmitDate.blank?
    
    accepted_apps = AdmSt.where(student_id: app.student_id).where(BannerTerm_BannerTerm: app.BannerTerm_BannerTerm).where("STAdmitted = 1 or STAdmitted IS NULL")

    if accepted_apps.size > 0 and app.new_record?
      app.errors.add(:base, "Student has already been admitted or has an open applicaiton in this term.")
    end

	end


  private

  def check_fks
    #validate the foreign keys and return true if all are good.
    self.errors.add(:student_id, "No student selected.") if self.student_id.blank?
    self.errors.add(:BannerTerm_BannerTerm, "No term could be determined.") if self.BannerTerm_BannerTerm.blank?
    self.errors.add(:student_file_id, "Please attach an admission letter.") unless (self.student_file_id or self.STAdmitted == nil)
    if self.errors.size == 0

      return true
    else
      return false
    end
  	
  end

end
