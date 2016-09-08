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

class PraxisResultTempsController < ApplicationController

  def index
    # display all results that need resolving
    @temps = PraxisResultTemp.all

  end

  def resolve
    # resolve the result
  end
end
