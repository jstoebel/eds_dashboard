require 'test_helper'
require 'application_controller'
class ConcernDashboardControllerTest < ActionController::TestCase

    allowed_roles = ["admin", "advisor"]
    role_names = Role.all.map{|i| i.RoleName}.to_a

    subject{get :index, params: {:student_id => @stu.id} }
    let(:praxis_concern){assigns(:concerns)[:praxis]}
    let(:issue_concern){assigns(:concerns)[:issues]}

    allowed_roles.each do |r|
        describe "as #{r}" do
           before do
                load_session(r)
                username = session[:user] # example "myname"

                # get the user with user name
                user = User.find_by :UserName => username

                # create an advisor with the user_id belonging to the above user
                @advisor = FactoryGirl.create :tep_advisor, {:user_id => user.id}
                @aa = FactoryGirl.create :advisor_assignment, {:tep_advisor_id => @advisor.id}
                @stu = @aa.student
           end # end before

          it "as #{r} returns http success" do
              subject
              assert_response :success
          end

          it "as #{r} pulls generic args for praxis" do
              subject
              expect praxis_concern[:title].must_equal "Praxis I"
              expect praxis_concern[:link].must_equal student_praxis_results_path(@stu.id)
              expect praxis_concern[:link_title].must_equal "View Praxis Results"
              expect praxis_concern[:link_num].must_equal @stu.praxis_results.size
          end

          it "as #{r} pulls args for praxis passing" do
              pop_praxisI(@stu, true)
              subject
              expect praxis_concern[:alert_status].must_equal "success"
              expect praxis_concern[:glyph].must_equal "ok-sign"
          end

          it "as #{r} pulls args for praxis failing" do
              pop_praxisI(@stu, false)
              subject
              expect praxis_concern[:alert_status].must_equal "danger"
              expect praxis_concern[:glyph].must_equal "warning-sign"

          end

          it "as #{r} pulls args for praxis no test" do
              subject
              expect praxis_concern[:alert_status].must_equal "info"
              expect praxis_concern[:glyph].must_equal "question-sign"
          end

          it "as #{r} pulls args for open issues" do
              FactoryGirl.create :issue, {:student_id => @stu.id, starting_status: :concern}
              subject
              expect issue_concern[:title].must_equal "Advisor Notes"
              expect issue_concern[:link].must_equal student_issues_path(@stu.id)
              expect issue_concern[:link_title].must_equal "View Advisor Notes"
              expect issue_concern[:link_num].must_equal @stu.issues.size
              expect issue_concern[:alert_status].must_equal "danger"
              expect issue_concern[:glyph].must_equal "warning-sign"
          end

          it "as #{r} pulls no args for no issue" do
              subject
              assert_nil issue_concern
          end


        end
    end

    # FOR PERMITTED ROLES

    (role_names - allowed_roles).each do |r|

        it "as #{r} can't index concerns bad role" do
          load_session(r)
          username = session[:user] # example "myname"

          # get the user with user name
          user = User.find_by :UserName => username

          # create an advisor with the user_id belonging to the above user
          @advisor = FactoryGirl.create :tep_advisor, {:user_id => user.id}

          @aa = FactoryGirl.create :advisor_assignment, {:tep_advisor_id => @advisor.id}
          @stu = @aa.student

          subject
          assert_redirected_to "/access_denied"
        end
    end

end
