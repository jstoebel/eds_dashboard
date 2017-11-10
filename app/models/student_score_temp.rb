# == Schema Information
#
# Table name: student_score_temps
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  item_level_id           :integer
#  scored_at               :datetime
#  full_name               :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  student_score_upload_id :integer
#

require 'active_record'
require 'orphanage'

class StudentScoreTemp < ActiveRecord::Base
    include Orphanage
    orphan :destroy_on_adopt => true
    
    belongs_to :student_score_upload
end
