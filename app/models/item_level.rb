# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#

=begin
represents a level belonging to an assessments
for example a single assessment item might have for different levels each with its own descriptor, 
level name and level number
=end

class ItemLevel < ActiveRecord::Base
    
    has_many :student_scores
    belongs_to :assessment_item

    validates_presence_of :descriptor, :level, :assessment_item_id
end
