# == Schema Information
#
# Table name: praxis_result_temps
#
#  id             :integer          not null, primary key
#  first_name     :string(255)
#  last_name      :string(255)
#  student_id     :integer
#  praxis_test_id :integer
#  test_date      :datetime
#  test_score     :integer
#  best_score     :integer
#

require 'test_helper'

class PraxisResultTempsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end
