# == Schema Information
#
# Table name: praxis_result_temps
#  id             :integer          not null, primary key
#  first_name     :string(255)
#  last_name      :string(255)
#  student_id     :integer
#  praxis_test_id :integer
#  test_date      :datetime
#  test_score     :integer
#  best_score     :integer
#

class PraxisResultTemp < ActiveRecord::Base

  has_many :praxis_sub_temps, :dependent => :delete_all
  belongs_to :praxis_test

  def finalize
    # make a record final by doing the following:
    # create a PraxisResult
    # create children PraxisSubtestResults
    # destroy self

    PraxisResultTemp.transaction do
      praxis_result = _transfer_pr
      _transfer_subs(praxis_result)
      self.destroy!
      return praxis_result
    end

  end


  private

  def _transfer_pr
    # attributes of self are used to generate a new PraxisResult
    # praxis_result is returned.
    desired_attrs = PraxisResult.column_names.reject{ |a| a=="id"}
    attrs = self.attributes.select{ |k, v| desired_attrs.include? k}
    praxis_result = PraxisResult.new(:from_ets => true)
    praxis_result.update_attributes! attrs
    return praxis_result
  end

  def _transfer_subs(praxis_result)
    # attributes for sub test of self are used to generate PraxuisSubtestResult
    # subtests will belong to praxis_result
    unwanted = ["id", "praxis_result_temp_id"]
    desired_attrs = PraxisSubtestResult.column_names.reject{|a| unwanted.include? a.to_s }
    self.praxis_sub_temps.each do |pst|
      attrs = pst.attributes.select{|k, v| desired_attrs.include? k.to_s}
      attrs.merge!({:praxis_result_id => praxis_result.id}) #add the pr_id

      PraxisSubtestResult.create! attrs
    end

  end

end
