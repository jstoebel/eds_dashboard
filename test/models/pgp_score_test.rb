# == Schema Information
#
# Table name: pgp_scores
#
#  id          :integer          not null, primary key
#  pgp_goal_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PgpScoreTest < ActiveSupport::TestCase
  test 'requires pgp_goal_id' do
    score = PgpScore.new
    score.valid?

    assert score.errors[:pgp_goal_id].include? 'can\'t be blank'
  end
end
