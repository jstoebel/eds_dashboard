class PendingStudentScore < ActiveRecord::Base
    
    belongs_to :assessment_version
    belongs_to :item_level
    belongs_to :assessment_item
    
    validates_presence_of :first_name, :last_name, :assessment_version_id, :assessment_item_id, :item_level_id
end