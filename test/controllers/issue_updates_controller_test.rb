# == Schema Information
#
# Table name: issue_updates
#
#  UpdateID                 :integer          not null, primary key
#  UpdateName               :text(65535)      not null
#  Description              :text(65535)      not null
#  Issues_IssueID           :integer          not null
#  tep_advisors_AdvisorBnum :integer          not null
#  created_at               :datetime
#  updated_at               :datetime
#  visible                  :boolean          default(TRUE), not null
#  addressed                :boolean
#  status                   :string(255)
#

require 'test_helper'
class IssueUpdatesControllerTest < ActionController::TestCase
  allowed_roles = ["admin", "advisor"]
  role_names = Role.all.pluck :RoleName

  test "should get new" do
    allowed_roles.each do |r|
      load_session(r)

      issue = FactoryGirl.create :issue  #add an update to this issue

      get :new, params: {:issue_id => issue.id}
      assert_response :success
      assert_equal issue, assigns(:issue)
      assert_equal issue.student, assigns(:student)

      #was a new update created?
      assert assigns(:update).new_record?
      assert_not assigns(:update).changed?

    end
  end

  describe "create" do

    before do
      @iu = FactoryGirl.create :issue_update
      @issue = @iu.issue
    end

    allowed_roles.each do |r|
      describe "allowed role: #{r}" do
        before do
          # user needs to be tep_advisor of student
          load_session(r)
          @user = User.find_by :UserName => session[:user]
          @advisor = FactoryGirl.create :tep_advisor, {:user_id => @user.id}

          # assign advisor to student
          AdvisorAssignment.create!({:student_id => @iu.student.id,
            :tep_advisor_id => @advisor.id
            })
        end

        test "success" do

          @iu.tep_advisors_AdvisorBnum = @advisor.id
          post :create, params: {:issue_id => @iu.issue.id, :issue_updates => @iu.attributes}

          #remove some attrs
          to_exclude = ["UpdateID", "created_at", "updated_at"]

          expected_attrs = @iu.attributes.except(*to_exclude)
          actual_attrs = assigns(:update).attributes.except(*to_exclude)

          # user needs to be a tep_advisor of student
          assert_redirected_to issue_issue_updates_path(assigns(:issue).IssueID)
          assert_equal "New update added", flash[:info]
          assert_equal expected_attrs, actual_attrs
          assert_equal @issue, assigns(:issue)

        end # success

        test "fail - bad params" do

          records0 = IssueUpdate.count

          params = @iu.attributes
          bad_params = @iu.attributes.merge("UpdateName" => nil)
          post :create, params: {:issue_id => @iu.issue.id, :issue_updates => bad_params}
          assert_response :success
          assert_template 'new'
          assert_equal 0, records0 - IssueUpdate.count

        end # fail

        describe 'email service down' do
          before do
            IssueUpdate
              .any_instance
              .stubs(:creation_alert)
              .raises(Net::SMTPAuthenticationError)

            @iu.tep_advisors_AdvisorBnum = @advisor.id
            post :create, params: {:issue_id => @iu.issue.id, :issue_updates => @iu.attributes}

          end

          test 'success - stores flash message' do
            assert_equal flash[:info], 'New update added'
          end

          test 'success - redirects' do
            assert_redirected_to issue_issue_updates_path(@iu.issue.IssueID)
          end

        end # email service down
        
      end # describe success

    end # allowed_roles

    (role_names - allowed_roles).each do |r|

      describe "access denied as #{r}" do
        before do
          load_session(r)
        end

        test "gets access denied" do
          post :create, params: {:issue_id => @iu.issue.id, :issue_updates => @iu.attributes}
          assert_redirected_to "/access_denied"
        end

      end # describe access denied
    end # roles loop

  end # create

  test "should get index" do
    allowed_roles.each do |r|
      load_session(r)
      update = FactoryGirl.create :issue_update
      issue = update.issue
      stu = issue.student

      get :index, params: {:issue_id => issue.id}

      assert_response :success
      assert_equal issue, assigns(:issue)
      assert_equal stu, assigns(:student)
      assert_equal issue.issue_updates.sorted, assigns(:updates)
    end
  end

  test "should patch update" do
    allowed_roles.each do |r|
      load_session(r)

      update = FactoryGirl.create :issue_update

      change_to = !update.addressed

      patch :update, params: {:id => update.id, :issue_update => {:addressed => change_to}}

      resp = JSON.parse @response.body
      assert_response :success
      assert_equal resp["addressed"], change_to
    end
  end

  test "should not patch update bad params" do
    #don't send a value for addressed
    allowed_roles.each do |r|
      load_session(r)

      update = FactoryGirl.create :issue_update

      change_to = !update.addressed

      patch :update, params: {:id => update.id, :issue_update => update.attributes.except("addressed")}

      resp = JSON.parse @response.body
      assert_response :unprocessable_entity
      assert_not_equal resp["addressed"], change_to
    end
  end

  #TESTS FOR UNAUTHORIZED USERS
  test "should not get new bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :new, params: {:issue_id => "who cares"}
      assert_redirected_to "/access_denied"
    end
  end

  test "should not get index bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      get :index, params: {:issue_id => "who cares"}
      assert_redirected_to "/access_denied"
    end
  end

  test "delete issue_update" do
    (allowed_roles).each do |r|
      load_session(r)
        stu = FactoryGirl.create(:student)
        admtep = FactoryGirl.create(:tep_advisor)
        iss = FactoryGirl.create(:issue, {:student_id => stu.id})
        iss_up = FactoryGirl.create(:issue_update, {:tep_advisors_AdvisorBnum => admtep.id,
        :Issues_IssueID => iss.id, :visible => true})
        delete :destroy, params: {:id => iss_up.id}
        assert_equal flash[:info], "Deleted Successfully!"
        assert_not assigns(:update).visible
        assert_redirected_to(issue_issue_updates_path(assigns(:update).issue.id))
    end
  end

  test "cannot delete" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
        stu = FactoryGirl.create(:student)
        tepadv = FactoryGirl.create(:tep_advisor)
        iss = FactoryGirl.create(:issue, {:student_id => stu.id})
        iss_up = FactoryGirl.create(:issue_update, {:tep_advisors_AdvisorBnum => tepadv.id,
        :Issues_IssueID => iss.id, :visible => true})
        delete :destroy, params: {:id => iss_up.id}
        assert_redirected_to "/access_denied"
    end
  end

  test "should not patch update bad role" do
    (role_names - allowed_roles).each do |r|
      load_session(r)
      update = FactoryGirl.create :issue_update
      change_to = !update.addressed
      patch :update, params: {:id => update.id, :issue_update => {:addressed => change_to}}
      assert_redirected_to "/access_denied"
    end
  end

end
