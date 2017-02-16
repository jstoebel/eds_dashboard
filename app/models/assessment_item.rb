# == Schema Information
#
# Table name: assessment_items
#
#  id          :integer          not null, primary key
#  slug        :string(255)
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

=begin
represents a single item that can belong to any number of different assessments
=end

class AssessmentItem < ActiveRecord::Base

    before_validation :check_scores
    before_destroy :check_scores

    belongs_to :assessment

    has_many :item_levels, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :item_levels

    validates_presence_of :name, :slug

    scope :sorted, lambda {order(:name => :asc)}

    def repr
      return self.slug
    end
    
    def has_scores?
      #Determines whether item is on version associated with score. Returns true if so
      # TODO
    end

    def check_scores
        if self.has_scores?
          self.errors.add(:base, "Can't modify item. Has associated scores.")
          return false
        else
          return true    #if there are no scores/can delete
        end
    end

end
