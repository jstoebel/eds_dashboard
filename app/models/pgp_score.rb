# == Schema Information
#
# Table name: pgp_scores
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


##
# an extension of the student_score model
# also references the corsponding pgp_score
class PgpScore < ApplicationRecord
  acts_as :student_score
  belongs_to :pgp_goal

  def ord
    assessment_item.ord
  end
end
