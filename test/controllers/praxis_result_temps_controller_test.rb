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

  allowed_roles = ["admin", "advisor", "staff", "student labor"]
  describe "index" do

    subject{get :index}

    test "returns http ok" do
      allowed_roles.each do |r|
        load_session(r)
        subject
        assert_response :success
      end
    end

    test "pulls all records" do
      allowed_roles.each do |r|
        load_session(r)
        subject
        assert_equal PraxisResultTemp.all, assigns(:temps)
      end
    end

  end

  describe "resolve" do

    subject {post :resolve, params: params}

    before do
      @stu = FactoryGirl.create :student
      @temp = FactoryGirl.create :praxis_result_temp, {:first_name => @stu.FirstName,
        :last_name => @stu.LastName}

    end

    describe "resolves record" do

      let(:params) { {:praxis_result_temp_id => @temp.id, :student_id => @stu.id} }

      test "removes temp" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert (PraxisResultTemp.find_by :id => @temp.id).nil?
        end

      end

      test "creates result" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert_equal 1, @stu.praxis_results.size
        end
      end

      test "stores flash message" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert_equal "Successfully resolved praxis record.", flash[:info]
        end
      end

      test "redirects" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert_redirected_to praxis_result_temps_path
        end
      end

    end

    describe "doesn't resolve record" do

      let(:params){{:praxis_result_temp_id => @temp.id, :student_id => nil}}

      test "doesn't remove temp" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert @temp.persisted?
        end
      end

      test "doesn't create result" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert_equal 0, @stu.praxis_results.size
        end

      end

      test "stores flash message" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert_equal "There was a problem resolving this record. Please try again later.", flash[:info]
        end

      end

      test "redirects" do
        allowed_roles.each do |r|
          load_session(r)
          subject
          assert_redirected_to praxis_result_temps_path
        end

      end

    end

  end

end
