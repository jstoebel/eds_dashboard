class BannerTerm < ActiveRecord::Base
	has_many :adm_tep, foreign_key: "BannerTerm_BannerTerm"
end
