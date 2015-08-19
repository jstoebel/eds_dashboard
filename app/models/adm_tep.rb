class AdmTep < ActiveRecord::Base
  self.table_name = 'adm_tep'

  has_one :program
  belongs_to :student, foreign_key: "Student_Bnum"

	validate do |app|
		app.errors.add(:base, "Please select a student to apply.") if app.Student_Bnum.blank?
		app.errors.add(:base, "Please select a program.") if app.Program_ProgCode.blank?
	end

  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}

  
end
