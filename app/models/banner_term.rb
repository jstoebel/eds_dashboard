class BannerTerm < ActiveRecord::Base
	has_many :adm_tep, foreign_key: "BannerTerm_BannerTerm"
	has_many :adm_st, foreign_key: "BannerTerm_BannerTerm"

	scope :from_date, ->(date) {where("StartDate <= ? and EndDate >= ?", date, date).first}
end
