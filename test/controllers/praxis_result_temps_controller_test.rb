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

  describe "index" do

    before do
      get :index
    end

    test "returns http ok" do
      assert_response :success
    end

    test "pulls all records" do
      assert_equal PraxisResultTemp.all, assigns(:temps)
    end

  end

  describe "resolve" do

    before do
      @stu = FactoryGirl.create :student
      @temp = FactoryGirl.create :praxis_result_temp, {:first_name => @stu.FirstName,
        :last_name => @stu.LastName}

    end

    describe "resolves record" do

      before do
        post :resolve, {:praxis_result_temp_id => @temp.id, :student_id => @stu.id}
      end

      test "removes temp" do
        assert (PraxisResultTemp.find_by :id => @temp.id).nil?
      end

      test "creates result" do
        assert_equal 1, @stu.praxis_results.size
      end

      test "stores flash message" do
        assert_equal "Successfully resolved praxis record.", flash[:notice]
      end

      test "redirects" do
        assert_redirected_to praxis_result_temps_path
      end

    end

    describe "doesn't resolve record" do

      before do
        post :resolve, {:praxis_result_temp_id => @temp.id, :student_id => nil}
      end

      test "doesn't remove temp" do
        assert @temp.persisted?
      end

      test "doesn't create result" do
        assert_equal 0, @stu.praxis_results.size
      end

      test "stores flash message" do
        assert_equal "There was a problem resolving this record. Please try again later.", flash[:notice]
      end

      test "redirects" do
        assert_redirected_to praxis_result_temps_path
      end

    end

  end

end
