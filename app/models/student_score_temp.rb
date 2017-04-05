require 'active_record'
require 'orphanage'

class StudentScoreTemp < ActiveRecord::Base
    include Orphanage
    orphan :destroy_on_adopt => true
end
