# == Schema Information
#
# Table name: pgps
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  goal_name   :string(255)
#  description :text(65535)
#  plan        :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  strategies  :text(65535)
#

class Pgp < ApplicationRecord
    self.table_name = 'pgps'


    before_destroy :pgp_scored_check

    belongs_to :student
    has_many :pgp_scores, dependent: :destroy


    scope :sorted, lambda {order(:created_at => :desc)}

    validates :student_id,
        presence: {message:"There must be an active student associated."}
    validates :goal_name,
        presence: {message:"Please enter a goal."}
    validates :description,
        presence: {message:"Please enter a description."}
    validates :plan,
        presence: {message:"Please enter a plan."}
    validates :strategies,
        presence: {message:"Please enter a strategy."}

    def latest_score
        self.pgp_scores.order(created_at: :desc).first
    end

    def pgp_scored_check
        # set up a validation that checks out if the pgp has a score, if it has a score, the goal name cannot be edited
        if self.pgp_scores.present?
            self.errors.add(:base, "Unable to alter due to scoring")
            throw :abort
        else
            return true
        end
    end


end
