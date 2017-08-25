# == Schema Information
#
# Table name: item_levels
#
#  id                  :integer          not null, primary key
#  assessment_item_id  :integer
#  descriptor          :text(65535)
#  level               :string(255)
#  ord                 :integer
#  created_at          :datetime
#  updated_at          :datetime
#  passing             :boolean
#  descriptor_stripped :text(65535)
#

=begin
represents a level belonging to an assessment
for example a single assessment item might have for different levels each with its own descriptor,
level name and level number
=end

class ItemLevel < ApplicationRecord

    belongs_to :assessment_item

    has_many :student_scores

    validates_presence_of :descriptor, :level, :assessment_item_id

    validates :descriptor,
      :uniqueness => {
        :message => "A level with that descriptor already exists for this assessment_item",
        :scope => [:assessment_item_id]
    }

    validates :level,
      :uniqueness => {
        :message => "A level with that level number already exists for this assessment_item",
        :scope => [:assessment_item_id]
    }

    validates :ord,
      :uniqueness => {
        :message => "A level with that ord already exists for this assessment_item",
        :scope => [:assessment_item_id]
    }

    scope :sorted, lambda {order(:ord => :asc)}

    def repr
      descriptor
    end

    def has_item_id?
      assessment_item_id.nil?
    end

    def after_import_save(record)
        self.descriptor_stripped = record[:descriptor].gsub(/\s/, '')
        save!
    end

end
