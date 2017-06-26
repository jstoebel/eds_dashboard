# == Schema Information
#
# Table name: praxis_sub_temps
#
#  id                    :integer          not null, primary key
#  praxis_result_temp_id :integer          not null
#  sub_number            :integer
#  name                  :string(255)
#  pts_earned            :integer
#  pts_aval              :integer
#  avg_high              :integer
#  avg_low               :integer
#

# an orphan sub test
class PraxisSubTemp < ApplicationRecord

  belongs_to :praxis_result_temp

end
