class PendingStudentScore < ActiveRecord::Base
    
    has_many :students  #through?
    belongs_to :assessment_version
    belongs_to :item_level
    belongs_to :assessment_item
    
    validates_presence_of :possible_stu,:assessment_version_id, :assessment_item_id, :item_level_id
end