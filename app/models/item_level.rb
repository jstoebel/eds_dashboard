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

    before_validation :check_scores, if: :has_item_id?
    before_destroy :check_scores

    has_many :student_scores
    belongs_to :assessment_item

    validates_presence_of :descriptor, :level, :assessment_item_id
    validates_uniqueness_of :ord, scope: :assessment_item_id

    scope :sorted, lambda {order(:ord => :asc)}

    def has_item_id?
      return self.assessment_item_id != nil
    end

    def lvl_scores?
      #returns true if level has scores
      return self.student_scores.present?
    end

    def check_scores
      if self.lvl_scores?    #if level has associated
        self.errors.add(:base, "Can't modify level. Has associated scores.")
        return false
      #if item has associated on any versions
      elsif self.assessment_item.has_scores? #there are associated scores
        self.errors.add(:base, "Can't modify level. The associated item has associated scores.")
        return false
      else
        return true
      end
    end

    def repr
      self.descriptor
    end
end
