# == Schema Information
#
# Table name: student_scores
#
#  id                    :integer          not null, primary key
#  student_id            :integer          not null
#  assessment_version_id :integer          not null
#  assessment_item_id    :integer          not null
#  item_level_id         :integer          not null
#  created_at            :datetime
#  updated_at            :datetime
#

class StudentScore < ActiveRecord::Base
    belongs_to :student
    belongs_to :item_level

    validates_presence_of :student_id, :item_level_id
end
