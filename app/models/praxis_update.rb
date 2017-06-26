# == Schema Information
#
# Table name: praxis_updates
#
#  id          :integer          not null, primary key
#  report_date :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

# an instance of an update run from ETS
class PraxisUpdate < ApplicationRecord
end
