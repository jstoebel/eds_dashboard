# == Schema Information
#
# Table name: pgp_strategies
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  name        :string(255)
#  timeline    :text(65535)
#  resources   :text(65535)
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PgpStrategy < ApplicationRecord
  belongs_to :pgp_goal
  after_validation :allow_three, unless: proc { |s| s.errors.any? }

  validates_presence_of :pgp_goal_id, :name, :timeline, :resources, :active

  validates :active,
            inclusion: { in: [true, false],
                         message: 'must be true or false' }

  ##
  # get the student owning this strategy
  def student
    pgp_goal.student
  end

  ##
  # each goal can only have three active at a time
  def allow_three
    other_strategies = pgp_goal.pgp_strategies
                               .where(active: true)
                               .where.not(id: id)

    if other_strategies.size >= 3

      errors.add(:base,
                 'Goal may only have three active strategies at any given ' \
                 'time.')
    end
  end # allow_three

end
