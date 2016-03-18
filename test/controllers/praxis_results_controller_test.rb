require 'test_helper'

class PraxisResultsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]    #roles who can do everything to this resource
  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      user = User.find(session[:user])
      
      test = PraxisResult.first
      stu = test.student

      get :index, {:student_id => stu.AltID}

      assert_response :success

      ability = Ability.new(user)
      assert_equal assigns(:tests), stu.praxis_results.select {|r| ability.can? :read, r }

    end
  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      user = User.find(session[:user])
      
      test = PraxisResult.first
      stu = test.student

      get :show, {:id => test.AltID}

      assert_response :success
      assert_equal test, assigns(:test)
      assert_equal stu, assigns(:student)

      ability = Ability.new(user)
      assert ability.can? :read, test

    end
  end

  test "should get new" do
    (allowed_roles + ['student labor']).each do |r|
      #student labor also has access to this
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:test).new_record?
      assert_not assigns(:test).changed?
    end
  end

  test "should post create" do
    (allowed_roles + ['student labor']).each do |r|
      #student labor also has access to this
      load_session(r)
      test = PraxisResult.first
      stu = test.student

      test.delete   #delete so we can create again

      test_params = {
        :AltID => stu.AltID, 
        :praxis_test_id => test.praxis_test_id, 
        :test_date => test.test_date, 
        :reg_date => test.reg_date, 
        :paid_by => test.paid_by
      }

      post :create, {:praxis_result => test_params}

      assert_equal assigns(:test).attributes.delete(:id), test.attributes.delete(:id)   #fixture record has id randomly generated
      assert_equal assigns(:student), stu
      assert_equal flash[:notice], "Registration successful: #{ApplicationController.helpers.name_details(stu)}, #{test.praxis_test_id}, #{test.test_date}"
      assert_redirected_to new_praxis_result_path
    end
  end

  test "should not post create bad record" do
    (allowed_roles + ['student labor']).each do |r|
      #student labor also has access to this
      load_session(r)
      test = PraxisResult.first

      test_params = {
        :AltID => test.student.AltID, 
        :praxis_test_id => test.praxis_test_id, 
        :test_date => test.test_date, 
        :reg_date => test.reg_date, 
        :paid_by => nil  #break the record here
      }

      post :create, {:praxis_result => test_params}

      assert_equal assigns(:students), Student.all.current.by_last
      assert_equal assigns(:test_options), PraxisTest.all.current
      assert_template ('new')
    end
  end

  ##TESTS FOR UNAUTHORIZED ROLES

  test "should not get index bad role" do
    ["staff", "student labor"].each do |r|
      load_session(r)

      test = PraxisResult.first
      stu = test.student
      get :index, {:student_id => stu.AltID}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get show bad role" do
    ["staff", "student labor"].each do |r|
      load_session(r)

      test = PraxisResult.first
      get :show, {:id => test.id}
      assert_redirected_to "/access_denied"

    end
  end

  test "should not get new bad role" do
    ["advisor"].each do |r|
      load_session(r)
      get :new
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post create bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = PraxisResult.first

      test_params = {
        :student_id => test.student_id, 
        :praxis_test_id => test.praxis_test_id, 
        :test_date => test.test_date, 
        :reg_date => test.reg_date, 
        :paid_by => nil  #break the record here
      }

      post :create, {:praxis_result => test_params}
      assert_redirected_to "/access_denied"
    end
  end

end
