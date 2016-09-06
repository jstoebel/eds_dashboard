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

class PraxisResultTempTest < ActiveSupport::TestCase


  describe "finalize" do

    before do
      @result_temp = FactoryGirl.create :praxis_result_temp
      @result_temp.student_id = (FactoryGirl.create :student).id
      @result_temp.save!
    end


    # RESULT TEMPS
    test "increases PraxisResult by 1" do
      pr0 = PraxisResult.count
      @result_temp.finalize
      assert_equal pr0 + 1, PraxisResult.count
    end

    test "created test matches temp" do
      @result_temp.finalize

      matching_keys =  ["student_id", "praxis_test_id", "test_date",
        "test_score", "best_score"]

      matching_attrs = @result_temp.attributes.select{|k,v| matching_keys.include? k.to_s}
      result = PraxisResult.find_by(matching_attrs)
      assert result.present?
    end

    test "decreases PraxisResultTemp by 1" do
      prt0 = PraxisResultTemp.count
      @result_temp.finalize
      assert_equal prt0 - 1, PraxisResultTemp.count
    end

    # SUBTESTS
    test "increases PraxisSubtestResult" do
      psr0 = PraxisSubtestResult.count
      @result_temp.finalize
      assert_equal psr0 + 4, PraxisSubtestResult.count
    end


    test "created subs match temp" do
      @result_temp.student_id = (FactoryGirl.create :student).id
      sub_temp_attrs = @result_temp.praxis_sub_temps.map{|pst| pst.attributes}
      result = @result_temp.finalize
      matching_keys =  ["sub_number", "name",
        "pts_earned", "pts_aval", "avg_high", "avg_low"]

      sub_temp_attrs.each do |pst|
        matching_attrs = pst.select{|k,v| matching_keys.include? k.to_s}
        sub_result = PraxisSubtestResult.find_by(matching_attrs.merge(
        {:praxis_result_id => result.id})
        )
        assert sub_result.present?
      end

    end

    test "decreases temps" do
      pst0 = PraxisSubTemp.count
      num_subs = @result_temp.praxis_sub_temps.size
      @result_temp.finalize
      assert_equal pst0 - num_subs, PraxisSubTemp.count
    end

  end

end
