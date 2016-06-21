class StudentScore < ActiveRecord::Base
    has_many :students
    has_many :assessment_versions
    has_many :item_levels
    has_many :assessment_items
    
    
end
