class AdmSt < ActiveRecord::Base
  self.table_name = 'adm_st'
  include ApplicationHelper

  has_attached_file :letter, 
	  :url => "/adm_st/:altid/download",		#passes AltID 
	  :path => ":rails_root/public/admission_letters/:bnum/:basename.:extension"

	validates_attachment_content_type :letter, :content_type => [ 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ]

  belongs_to :student, foreign_key: "Student_Bnum"
  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}
end
