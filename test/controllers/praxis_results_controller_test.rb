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
#

require 'test_helper'
class PraxisResultsControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]    #roles who can do everything to this resource

  #taken from clinical_assignments. It works there!

  test "should get index" do
    role_names.each do |r|
      load_session(r)
      user = User.find_by(:UserName => session[:user])

      # test = PraxisResult.first
      p_test = FactoryGirl.create :praxis_test
      test = FactoryGirl.create :praxis_result, :praxis_test_id => p_test.id

      stu = test.student

      get :index, params: {:student_id => stu.AltID}

      assert_response :success

      ability = Ability.new(user)
      assert_equal assigns(:tests), stu.praxis_results.select {|r| ability.can? :index, r }

    end
  end

  test "should get show" do
    allowed_roles.each do |r|
      load_session(r)

      user = User.find_by(:UserName => session[:user])
      adv = FactoryGirl.create :tep_advisor, :user => user
      test = FactoryGirl.create :praxis_result
      stu = test.student
      AdvisorAssignment.create({:student_id => stu.id,
          :tep_advisor_id => adv.id
        })
      get :show, params: {:id => test.AltID}

      assert_response :success
      assert_equal test, assigns(:test)
      assert_equal test.student, assigns(:student)

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

      result = FactoryGirl.build :praxis_result
      stu = result.student

      allowed_attrs = [:student_id, :praxis_test_id, :test_date, :reg_date, :paid_by]
      post :create, params: {:praxis_result => result.attributes}

      #created result should match across allowed_attrs
      expected_attrs = result.attributes.slice(*allowed_attrs)
      actual_attrs = assigns(:test).attributes.slice(*allowed_attrs)
      assert_equal expected_attrs, actual_attrs
      assert_redirected_to new_praxis_result_path, assigns(:test).errors.full_messages
      assert_equal flash[:notice], "Registration successful: #{stu.name_readable}, #{result.praxis_test.TestName}, #{result.test_date.strftime("%m/%d/%Y")}"
      assert_equal assigns(:student), result.student

    end
  end

  test "should not post create bad record" do
    (role_names - ["advisor"]).each do |r|
      #student labor also has access to this
      load_session(r)
      test = FactoryGirl.create :praxis_result

      test_params = {
        :id => test.student.id,
        :praxis_test_id => test.praxis_test_id,
        :test_date => test.test_date,
        :reg_date => test.reg_date,
        :paid_by => nil  #break the record here
      }

      post :create, params: {:praxis_result => test_params}

      assert_equal assigns(:students), Student.all.by_last.current
      assert_equal assigns(:test_options), PraxisTest.all.current
      assert_template ('new')
    end
  end

  test "should get edit" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)

      test = FactoryGirl.create :praxis_result
      get :edit, params: {:id => test.id}
      assert_response :success
      assert_equal test, assigns(:test)
    end
  end

  test "should not get edit test locked" do
    #tests with a score should not be editable
    (role_names - ["advisor"]).each do |r|
      load_session(r)

      test = FactoryGirl.create :praxis_result
      test.test_score = 123
      test.save
      get :edit, params: {:id => test.id}
      assert_equal flash[:notice], "Test may not be altered."
      assert_redirected_to student_praxis_results_path(test.student.AltID)
    end
  end

  test "should post update" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)

      test = FactoryGirl.create :praxis_result, :test_score => nil
      test.reg_date += 1
      update_params = {:reg_date => test.reg_date}
      post :update, params: {:id => test.id,
       :praxis_result => update_params
      }

      assert test.valid?, test.errors.full_messages
      assert_redirected_to student_praxis_results_path(test.student.id)

      expected_attributes = test.attributes.except(:id)
      actual_attributes = assigns(:test).attributes.except(:id)
      assert_equal expected_attributes, actual_attributes
    end
  end

  test "should not post update locked" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      # test = PraxisResult.first
      test = FactoryGirl.create :praxis_result


      test.test_score = 123
      test.save
      test.reg_date += 1

      update_params = {:reg_date => test.reg_date}

      post :update, params: {:id => test.AltID,
       :praxis_result => update_params
      }
      assert_equal flash[:notice], "Can't update test #{ApplicationController.helpers.name_details(test.student)}, #{PraxisTest.find(test.praxis_test_id).TestName}, #{test.test_date.strftime("%m/%d/%Y")}"
      assert_template 'edit'

    end
  end

  test "should not post update bad params" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      # test = PraxisResult.first
      test = FactoryGirl.create :praxis_result
      test.reg_date = nil

      update_params = {:reg_date => test.reg_date}

      post :update, params: {:id => test.id,
       :praxis_result => update_params
      }

      assert_equal flash[:notice], "Can't update test #{ApplicationController.helpers.name_details(test.student)}, #{PraxisTest.find(test.praxis_test_id).TestName}, #{test.test_date.strftime("%m/%d/%Y")}"
      assert_template 'edit'
    end
  end

  test "should post destroy" do
    (role_names - ["advisor"]).each do |r|
      load_session(r)
      # test = PraxisResult.first
      student = FactoryGirl.create :student
      test = FactoryGirl.create :praxis_result, :test_score => nil

      alt_id = test.student.AltID

      #destroy each subtest

      sub_tests = test.praxis_subtest_results
      sub_tests.destroy_all

      post :destroy, params: {:id => test.id}
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
      student = FactoryGirl.create :student
      test = FactoryGirl.create :praxis_result
      test.test_score = 123
      test.save
      post :destroy, params: {:id => test.AltID}
      assert_redirected_to student_praxis_results_path(test.student.AltID)
      assert_not PraxisResult.find_by(:id => test.id).destroyed?
    end
  end

  ##TESTS FOR UNAUTHORIZED ROLES

  test "should not get show bad role" do
    ["staff", "student labor"].each do |r|
      load_session(r)

      test = FactoryGirl.create :praxis_result
      get :show, params: {:id => test.id}
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
      test = FactoryGirl.create :praxis_result

      test_params = {
        :student_id => test.student_id,
        :praxis_test_id => test.praxis_test_id,
        :test_date => test.test_date,
        :reg_date => test.reg_date,
        :paid_by => nil  #break the record here
      }

      post :create, params: {:praxis_result => test_params}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get edit bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = FactoryGirl.create :praxis_result
      get :edit, params: {:id => test.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post update bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = FactoryGirl.create :praxis_result
      test.reg_date += 1
      update_params = {:reg_date => test.reg_date}
      post :update, params: {:id => test.id,
       :praxis_results => update_params
      }
      assert_redirected_to "/access_denied"
    end
  end

  test "should not post destroy bad role" do
    ["advisor"].each do |r|
      load_session(r)
      test = FactoryGirl.create :praxis_result
      test.test_score = 123
      test.save
      post :destroy, params: {:id => test.id}
      assert_redirected_to "/access_denied"
    end
  end

end
