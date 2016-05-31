# == Schema Information
#
# Table name: student_scores
#
#  id                    :integer          not null, primary key
#  student_id            :integer
#  assessment_version_id :integer
#  item_level_id         :integer
#  assessment_item_id    :integer
#

class StudentScore < ActiveRecord::Base
    #~~~ASSOCIATIONS ~~~

    belongs_to :student
    belongs_to :assessment_version
    belongs_to :item_level
    belongs_to :assessment_item

    #~~~VALIDATIONS ~~~

    validates :student_id, presence: true
    validates :assessment_version_id, presence: true
    validates :item_level_id, presence: true
    validates :assessment_item_id, presence: true

end
