# == Schema Information
#
# Table name: banner_updates
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  start_term :integer
#  end_term   :integer
#

class BannerUpdate < ActiveRecord::Base

	# before_validation :check_terms
    validates_presence_of :start_term, :end_term
    validates_numericality_of :start_term, :less_than_or_equal_to => :end_term

    # private
	# def check_terms
	# 	if self.start_term > self.end_term
	# 		self.errors.add(:base, "Start term may not be after end term.")
	# 	end
	# end

end
