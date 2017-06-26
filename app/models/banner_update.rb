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

# represents a record in updating from banner.
class BannerUpdate < ApplicationRecord

	# before_validation :check_terms
    validates_presence_of :start_term, :end_term
    validates_numericality_of :start_term, :less_than_or_equal_to => :end_term

end
