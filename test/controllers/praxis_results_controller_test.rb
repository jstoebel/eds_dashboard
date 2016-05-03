# == Schema Information
#
# Table name: praxis_results
#
#  id             :integer          not null, primary key
#  student_id     :integer          not null
#  praxis_test_id :integer
#  test_date      :datetime
#  reg_date       :datetime
#  paid_by        :string(255)
#  test_score     :integer
#  best_score     :integer
#  cut_score      :integer
#

require 'test_helper'

class PraxisResultsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]    #roles who can do everything to this resource

  #taken from clinical_assignments. It works there!

  test "should get index" do
    role_names.each do |r|
      load_session(r)
      user = User.find_by(:UserName => session[:user])
      
      test = PraxisResult.first
      stu = test.student

      get :index, {:student_id => stu.AltID}

      assert_response :success

      ability = Ability.new(user)
      assert_equal assigns(:tests), stu.praxis_results.select {|r| ability.can? :index, r }

    end
  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)
      user = User.find_by(:UserName => session[:user])
      #find a test -> student -> advisor
      related_student = user.tep_advisor.advisor_assignments.first.student
      test = related_student.praxis_results.first

      get :show, {:id => test.AltID}

      assert_response :success
      assert_equal test, assigns(:test)
      assert_equal related_student, assigns(:student)

      ability = Ability.new(user)
      assert (ability.can? :read, test)

    end
  end

  test "should get new" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      get :new
      assert_response :success
      assert assigns(:test).new_record?
      assert_not assigns(:test).changed?
    end
  end

  test "should post create" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)

      stu = Student.first
      test = PraxisResult.first

      subs = test.praxis_subtest_results
      subs.destroy_all
      test.destroy
      test_params = test.attributes

      test_params = {
        :id => stu.id,
        :praxis_test_id => PraxisTest.first.id, 
        :test_date => Date.today, 
        :reg_date => Date.today, 
        :paid_by => "ETS (fee waiver)"        
      }

      post :create, {:praxis_result => test_params}

      expected_attrs = test_params.except(:AltID).stringify_keys
      actual_attrs = assigns(:test).attributes

      assert expected_attrs, actual_attrs
      assert_redirected_to new_praxis_result_path, assigns(:test).errors.full_messages


      assert_equal flash[:notice], "Registration successful: #{ApplicationController.helpers.name_details(stu)}, #{PraxisTest.find(test_params[:praxis_test_id]).TestName}, #{test_params[:test_date].strftime("%m/%d/%Y")}"
      assert_equal assigns(:student), stu

      assigns(:test).delete

      PraxisResult.create test.attributes

      subs = test.praxis_subtest_results
      subs.each do |s|
        new_sub = PraxisSubtestResult.new s.attributes
        new_sub.save
      end

    end
  end

  test "should not post create bad record" do
    (role_names - ["advisor"]).each do |r|
      #student labor also has access to this
      load_session(r)
      test = PraxisResult.first

      test_params = {
        :id => test.student.id, 
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

  test "should get edit" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)

      test = PraxisResult.first
      get :edit, {:id => test.AltID}
      assert_response :success
      assert_equal test, assigns(:test)
    end
  end

  test "should not get edit test locked" do
    #tests with a score should not be editable
    (role_names - ["advisor"]).each do |r|
      load_session(r)

      test = PraxisResult.first
      test.test_score = 123
      test.save
      get :edit, {:id => test.AltID}
      assert_equal flash[:notice], "Test may not be altered."
      assert_redirected_to student_praxis_results_path(test.student.AltID)
    end
  end

  test "should post update" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      test = PraxisResult.first

      test.reg_date += 1

      update_params = {:reg_date => test.reg_date}

      post :update, {:id => test.AltID,
       :praxis_result => update_params
      }

      assert_redirected_to student_praxis_results_path(test.student.AltID)

      expected_attributes = test.attributes.delete(:id)
      actual_attributes = assigns(:test).attributes.delete(:id)
      assert_equal expected_attributes, actual_attributes
    end
  end

  test "should not post update locked" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      test = PraxisResult.first

      test.test_score = 123
      test.save
      test.reg_date += 1

      update_params = {:reg_date => test.reg_date}

      post :update, {:id => test.AltID,
       :praxis_result => update_params
      }
      assert_equal flash[:notice], "Can't update test #{ApplicationController.helpers.name_details(test.student)}, #{PraxisTest.find(test.praxis_test_id).TestName}, #{test.test_date.strftime("%m/%d/%Y")}"
      assert_template 'edit'

    end
  end

  test "should not post update bad params" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      test = PraxisResult.first

      test.reg_date = nil

      update_params = {:reg_date => test.reg_date}

      post :update, {:id => test.AltID,
       :praxis_result => update_params
      }

      assert_equal flash[:notice], "Can't update test #{ApplicationController.helpers.name_details(test.student)}, #{PraxisTest.find(test.praxis_test_id).TestName}, #{test.test_date.strftime("%m/%d/%Y")}"
      assert_template 'edit'
    end
  end

  test "should post destroy" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      test = PraxisResult.first
      alt_id = test.student.AltID

      #destroy each subtest

      sub_tests = test.praxis_subtest_results
      sub_tests.destroy_all

      post :destroy, {:id => test.AltID}
      assert_redirected_to student_praxis_results_path(alt_id)
      assert_nil PraxisResult.find_by(:id => test.id)

      #bring the record back
      new_test = PraxisResult.new(test.attributes)
      new_test.id = nil
      new_test.save

      #bring back the subtests
      sub_tests.each do |s|
        new_sub = PraxisSubtestResult.new s.attributes
        new_sub.save
      end

    end
  end

  test "should not post destroy locked" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      test = PraxisResult.first
      test.test_score = 123
      test.save
      post :destroy, {:id => test.AltID}
      assert_redirected_to student_praxis_results_path(test.student.AltID)
      assert_not PraxisResult.find_by(:id => test.id).destroyed?      
    end    
  end

  ##TESTS FOR UNAUTHORIZED ROLES

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

  test "should not get edit bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = PraxisResult.first
      get :edit, {:id => test.AltID}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post update bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = PraxisResult.first
      test.reg_date += 1
      update_params = {:reg_date => test.reg_date}
      post :update, {:id => test.AltID,
       :praxis_results => update_params
      }
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post destroy bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = PraxisResult.first
      test.test_score = 123
      test.save
      post :destroy, {:id => test.AltID}
      assert_redirected_to "/access_denied"
    end
  end

end

