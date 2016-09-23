require 'test_helper'
require 'application_controller'
class ConcernDashboardControllerTest < ActionController::TestCase

    allowed_roles = ["admin", "advisor"]
    role_names = Role.all.map{|i| i.RoleName}.to_a

    before do
        @stu = Student.first
    end

    subject{get :index, :student_id => @stu.id}
    let(:praxis_concern){assigns(:concerns)[:praxis]}
    let(:issue_concern){assigns(:concerns)[:issues]}

    # FOR PERMITTED ROLES

    allowed_roles.each do |r|
        it "as #{r} returns http success" do
            load_session r
            subject
            assert_response :success

        end

        it "as #{r} pulls generic args for praxis" do
            load_session r
            subject
            expect praxis_concern[:title].must_equal "Praxis I"
            expect praxis_concern[:link].must_equal student_praxis_results_path(@stu.id)
            expect praxis_concern[:link_title].must_equal "View Praxis Results"
            expect praxis_concern[:link_num].must_equal @stu.praxis_results.size
        end

        it "as #{r} pulls args for praxis passing" do
            load_session r
            pop_praxisI(@stu, true)
            subject
            expect praxis_concern[:alert_status].must_equal "success"
            expect praxis_concern[:glyph].must_equal "ok-sign"
        end

        it "as #{r} pulls args for praxis failing" do
            load_session r
            pop_praxisI(@stu, false)
            subject
            expect praxis_concern[:alert_status].must_equal "danger"
            expect praxis_concern[:glyph].must_equal "warning-sign"

        end

        it "as #{r} pulls args for praxis no test" do
            load_session r
            PraxisSubtestResult.delete_all
            PraxisResult.delete_all
            subject
            expect praxis_concern[:alert_status].must_equal "info"
            expect praxis_concern[:glyph].must_equal "question-sign"

        end

        it "as #{r} pulls args for open issues" do
            load_session r
            FactoryGirl.create :issue, {:student_id => @stu.id, :Open => true}
            subject
            expect issue_concern[:title].must_equal "Advisor Notes"
            expect issue_concern[:link].must_equal student_issues_path(@stu.id)
            expect issue_concern[:link_title].must_equal "View Advisor Notes"
            expect issue_concern[:link_num].must_equal @stu.issues.size
            expect issue_concern[:alert_status].must_equal "danger"
            expect issue_concern[:glyph].must_equal "warning-sign"
        end

        it "as #{r} pulls no args for no issue" do
            load_session r
            IssueUpdate.delete_all
            Issue.delete_all
            subject
            expect issue_concern.must_equal nil
        end
    end

    (role_names - allowed_roles).each do |r|

        it "as #{r} can't index concerns bad role" do
            load_session r
            subject
            assert_redirected_to "/access_denied"
        end
    end

end
