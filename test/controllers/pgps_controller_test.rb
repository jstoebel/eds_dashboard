require 'test_helper'

class PgpsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # 
  
  allowed_roles = ["admin", "staff"] 
  
  test "get index" do
    allowed_roles.each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      
      get :index, {:student_id => stu.id}
      assert_response :success
      
    end
  end
  
  test "index bad role" do
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      
      get :index, {:student_id => stu.id}
    end
  end
      
  test "should create pgp" do 
    allowed_roles.each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      create_pgp = {:pgp => {:student_id => stu.id,
      :goal_name => "Test Name",
      :description => "Test Descript",
      :plan => "Test plan"}
      }
      post :create, create_pgp
      assert assigns(:pgp).valid?
      assert_equal flash[:notice], "Created professional growth plan."
      assert_redirected_to student_pgps_path(assigns(:pgp).student_id)
    end
  end
  
  test "bad role shoud not create pgp" do 
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      post :create, {:student_id => stu.id}
      assert_redirected_to student_pgps_path
      assert_equal assigns(:pgp), pgp.id
      assert_equal flash[:notice], "Error creating professional growth plan."
    end
  end
  
  test "should update pgp" do 
    
    stu = FactoryGirl.create :student
  
    allowed_roles.each do |r|
      load_session(r)
      
      pgp = FactoryGirl.create :pgp, 
      {:student_id => stu.id, :goal_name => "test name",:description => "nil", :plan => "nil"}
      expected_attr = {:description => "new descript", :plan => "new plan"}
      post :update, {:id => pgp.id, :pgp => expected_attr}
      assert_equal(assigns(:pgp), pgp)
      assert_redirected_to student_pgps_path(assigns(:pgp).student_id)
    end
  end
  
  test "should not edit/update - bad role" do 
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      post :edit, {:pgp => pgp.id}
      assert_equal flash[:notice] = "Error in editing PGP."
    end
  end
  
  test "Should Delete PGP" do 
    allowed_roles.each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      post :destroy, {:id => pgp.id}
      assert_equal(assigns(:pgp), pgp)
      assert assigns(:pgp).destroyed?
      assert_equal flash[:notice], "Professional growth plan deleted successfully"
      assert_redirected_to student_pgps_path(assigns(:pgp).student_id)
    end
  end
  
  test "Should not delete - bad role" do 
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp 
      post :destroy, {:id => pgp.id}
      assert_equal flash[:notice], "Professional growth plan unable to be deleted due to being scored"
      assert_redirected_to student_pgps_path(assigns(:pgp).student_id)
    end
  end
  
  test "shouldn't delete - has scores" do 
    allowed_roles.each do |r|
      load_session(r)
      score = FactoryGirl.create :pgp_score
      post :destroy, {:id => score.pgp.id}
      assert_equal flash[:notice], "Professional growth plan unable to be deleted due to being scored"
    end
  end
  

    
    
  
  
end
