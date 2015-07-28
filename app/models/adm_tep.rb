class AdmTep < ActiveRecord::Base
  self.table_name = 'adm_tep'

  scope :by_term, ->(term) {where("BannerTerm_BannerTerm = ?", term)}

  
end
