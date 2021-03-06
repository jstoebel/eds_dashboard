##
# == Schema Information
#
# Table name: pgp_goals
#
#  id         :integer          not null, primary key
#  student_id :integer
#  name       :string(255)
#  domain     :string(255)
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PgpGoal < ApplicationRecord
  belongs_to :student
  has_many :pgp_strategies, dependent: :delete_all
  has_many :pgp_scores, dependent: :delete_all

  after_validation :allow_three, unless: proc { |s| s.errors.any? }

  # domain must be a valid Danielson Domain name
  DOMAINS = [
    'Planning and Preparation',
    'Classroom Environment',
    'Instruction',
    'Professional Responsibilities'
  ].freeze

  validates_presence_of :student_id, :name, :domain

  validates :active,
            inclusion: { in: [true, false],
                         message: 'must be true or false' }

  validates :domain,
            inclusion: { in: DOMAINS,
                         message: 'Please select a valid Danielson domain' }

  def self.domains
    DOMAINS
  end

  ##
  # each student can only have three active at a time
  def allow_three
    other_goals = student.pgp_goals
                    .where(active: true)
                    .where.not(id: self.id)
    
    errors.add(:base,
               'Student may only have three active PGP goals at any given ' \
               'time.') if other_goals.size >= 3    
  end # allow_three
  
end
