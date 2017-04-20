# == Schema Information
#
# Table name: student_scores
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  item_level_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class StudentScore < ApplicationRecord
    belongs_to :student
    belongs_to :item_level

    validates_presence_of :student_id, :item_level_id, :scored_at
end
