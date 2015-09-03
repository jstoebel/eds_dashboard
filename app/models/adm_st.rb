class AdmSt < ActiveRecord::Base
  self.table_name = 'adm_st'
  include ApplicationHelper
  belongs_to :student, foreign_key: "Student_Bnum"
  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}
end
