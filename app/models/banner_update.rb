# == Schema Information
#
# Table name: banner_updates
#
#  id          :integer          not null, primary key
#  upload_date :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class BannerUpdate < ActiveRecord::Base

	before_validation :check_terms

	private
	def check_terms
		if self.start_term >= self.end_term
			self.errors.add(:base, "Start term must be before end term")
		end
	end

end
