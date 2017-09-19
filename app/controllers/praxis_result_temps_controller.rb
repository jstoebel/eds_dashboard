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
    # when an orphan record needs to be merged into the home Table
    # TODO: refactor to use Orphanage

    temp_record = PraxisResultTemp.find params[:praxis_result_temp_id]
    temp_record.student_id = params[:student_id]
    begin
      temp_record.finalize
      flash[:info] = "Successfully resolved praxis record."
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed, ActiveRecord::InvalidForeignKey => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      flash[:info] = 'There was a problem resolving this record. Please try ' \
                     'again later.'
    end
    redirect_to praxis_result_temps_path
  end
end
