# == Schema Information
#
# Table name: pgps
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  goal_name   :string(255)
#  description :text(65535)
#  plan        :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#  strategies  :text(65535)
#

require 'test_helper'

class PgpsControllerTest < ActionController::TestCase

  allowed_roles = ["admin", "advisor"]
  roles = Role.all.pluck :RoleName

  test "get index" do
    allowed_roles.each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      get :index, params: {:student_id => stu.id}
      assert_response :success
      expected_pgp = Pgp.all
      assert_equal assigns(:pgps).to_a, expected_pgp.to_a

    end
  end

  test "index bad role" do
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      get :index, params: {:student_id => stu.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "should get new" do

  end

  describe "create" do
    allowed_roles.each do |r|
      describe "as #{r}" do

        before do
          load_session(r)
          @adv_assign = FactoryGirl.create :advisor_assignment, {:tep_advisor => (
            FactoryGirl.create :tep_advisor, {:user => (User.find_by :UserName => session[:user])}
            )
          }

          stu = @adv_assign.student
          assert stu.is_advisee_of @adv_assign.tep_advisor

        end

        test "should create" do

          expected_pgp = FactoryGirl.build :pgp, {:student => @adv_assign.student}
          stu = expected_pgp.student
          post :create, params: {:pgp=> expected_pgp.attributes}
          assert assigns(:pgp).valid?
          assert_equal flash[:info], "Created professional growth plan."
          assert_equal expected_pgp.attributes.except("id", "created_at", "updated_at"),
          assigns(:pgp).attributes.except("id", "created_at", "updated_at")
          assert_redirected_to student_pgps_path(assigns(:pgp).student_id)
        end

        test "should not create - bad params" do

          stu = @adv_assign.student
          adv = @adv_assign.tep_advisor

          assert stu.is_advisee_of adv

          expected_pgp = FactoryGirl.build :pgp, {:student => stu,
            :goal_name => nil
          }
          post :create, params: {:pgp=> expected_pgp.attributes}

          assert_not assigns(:pgp).valid?
          assert_template 'new'
          assert_equal flash[:info], "Error creating professional growth plan."
          assert_equal stu, assigns(:student)
        end # test

      end # inner describe
    end # allowed roles


    (roles - allowed_roles).each do |r|
      test "bad role shoud not create pgp" do
        load_session(r)
        stu = FactoryGirl.create :student
        pgp = FactoryGirl.create :pgp
        post :create, params: {:student_id => stu.id}
        assert_redirected_to "/access_denied"
      end
    end

  end # outer describe



  test "should update pgp" do

    stu = FactoryGirl.create :student

    allowed_roles.each do |r|
      load_session(r)

      pgp = FactoryGirl.create :pgp,
      {:student_id => stu.id, :goal_name => "test name",:description => "description", :plan => "plan"}
      expected_attr = {"description" => "new descript", "plan" => "new plan"}
      post :update, params: {:id => pgp.id, :pgp => expected_attr}

      all_attrs = assigns(:pgp).attributes
      actual_attrs = all_attrs.select{ |k,v| expected_attr.include?(k)}

      assert_equal actual_attrs, expected_attr
      assert_equal(assigns(:pgp), pgp)
      assert_equal assigns(:student), pgp.student

      assert assigns(:pgp).valid?

      assert_equal flash[:info], "PGP successfully updated"
      assert_redirected_to student_pgps_path(assigns(:pgp).student_id)

    end
  end

  test "should not update pgp - bad params" do

    stu = FactoryGirl.create :student

    allowed_roles.each do |r|
      load_session(r)

      pgp = FactoryGirl.create :pgp,
      {:student_id => stu.id, :goal_name => "test name",:description => "description", :plan => "plan"}
      expected_attr = {:description => "new descript", :plan => nil}
      post :update, params: {:id => pgp.id, :pgp => expected_attr}

      assert_equal(assigns(:pgp), pgp)
      assert_equal pgp.student, assigns(:student)
      assert_not assigns(:pgp).valid?
      assert_equal flash[:info], "Error in editing PGP."
      assert_template 'edit'
      assert_response :success

    end
  end

  test "should not update bad role" do
    stu = FactoryGirl.create :student

    (roles - allowed_roles).each do |r|
      load_session(r)

      pgp = FactoryGirl.create :pgp,
      {:student_id => stu.id, :goal_name => "test name",:description => "nil", :plan => "nil"}
      expected_attr = {:description => "new descript", :plan => "new plan"}
      post :update, params: {:id => pgp.id, :pgp => expected_attr}
      assert_redirected_to "/access_denied"
    end
  end


  test "should not edit - bad role" do
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      post :edit, params: {:id => pgp.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "Should destroy PGP" do
    allowed_roles.each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      pgp = FactoryGirl.create :pgp
      post :destroy, params: {:id => pgp.id}
      assert_equal(assigns(:pgp), pgp)
      assert assigns(:pgp).destroyed?
      assert_equal flash[:info], "Professional growth plan deleted successfully"
      assert_redirected_to student_pgps_path(assigns(:pgp).student_id)
    end
  end

  test "Should not destroy - bad role" do
    (roles - allowed_roles).each do |r|
      load_session(r)
      stu = FactoryGirl.create :student
      score = FactoryGirl.create :pgp_score
      pgp = score.pgp
      post :destroy, params: {:id => pgp.id}
      assert_redirected_to "/access_denied"
    end
  end

  test "shouldn't destroy - has scores" do
    allowed_roles.each do |r|
      load_session(r)
      pgp = FactoryGirl.create :pgp
      score = FactoryGirl.create :pgp_score, {:pgp_id => pgp.id}
      post :destroy, params: {:id => pgp.id}
      assert_equal flash[:info], "Unable to alter due to scoring"
      assert_equal assigns(:pgp), pgp
    end
  end

end
