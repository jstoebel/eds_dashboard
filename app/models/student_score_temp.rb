require 'active_record'
require 'orphanage'

class StudentScoreTemp < ActiveRecord::Base
    include Orphanage
    orphan :destroy_on_adopt => true
    
    belongs_to :student_score_upload
end
