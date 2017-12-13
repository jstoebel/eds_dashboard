
# == Schema Information
#
# Table name: assessment_items
#
#  id            :integer          not null, primary key
#  assessment_id :integer
#  name          :string(255)
#  slug          :string(255)
#  start_term    :integer
#  end_term      :integer
#  description   :text(65535)
#  created_at    :datetime
#  updated_at    :datetime
#  ord           :integer
#
# represents a single item that can belong to
# any number of different assessments
class AssessmentItem < ApplicationRecord
  belongs_to :assessment

  has_many :item_levels, dependent: :destroy
  has_many :student_scores, through: :item_levels

  validates_presence_of :name, :slug, :ord

  validates :name,
            uniqueness: {
              message: 'An item with that name already exists for this '\
                       'assessment',
              scope: [:assessment_id]
            }

  validates :description,
            uniqueness: {
              message: 'An item with that description already exists for this '\
                       'assessment',
              scope: [:assessment_id]
            }

  validates :ord,
            uniqueness: {
              message: 'An item with that ord already exists for this '\
                       'assessment',
              scope: [:assessment_id]
            }

  scope :sorted, -> { order ord: :asc }

  def repr
    slug
  end
end
