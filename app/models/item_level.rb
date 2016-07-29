# == Schema Information
#
# Table name: item_levels
#
#  id                 :integer          not null, primary key
#  assessment_item_id :integer          not null
#  descriptor         :text(65535)
#  level              :string(255)
#  ord                :integer
#  created_at         :datetime
#  updated_at         :datetime
#  cut_score          :boolean
#

=begin
represents a level belonging to an assessments
for example a single assessment item might have for different levels each with its own descriptor, 
level name and level number
=end

class ItemLevel < ActiveRecord::Base
            
    before_validation :check_scores #test that does stop, that doesn't when shouldn't
    before_destroy :check_scores
    
    has_many :student_scores
    belongs_to :assessment_item

    validates_presence_of :descriptor, :level, :assessment_item_id
    
    scope :sorted, lambda {order(:ord => :asc)}
    
    def has_scores?
      return self.student_scores.present?
    end
    
    private
    def check_scores
        if self.has_scores?    #if true
          self.errors.add(:base, "Can't delete level. Has associated scores.")   
          return false
      end
  end
end
