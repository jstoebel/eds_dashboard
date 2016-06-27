require 'test_helper'
require 'test_teardown'
class ConcernDashboardControllerTest < ActionController::TestCase
    include TestTeardown

    allowed_roles = ["admin", "advisor"]

    before do
        @stu = Student.first
        # role_names.each do |role|
        #     usr = instance_variable_set("@#{role}", FactoryGirl.create(role))
        #     adv = instance_variable_set("@#{role}_adv", (FactoryGirl.create :tep_advisor, {:user_id => usr.id}))
        #     FactoryGirl.create :advisor_assignment, {:student_id => @stu.id, :tep_advisor_id => adv.id }
        # end
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




    # describe "index success" do

    #     let(:stu){FactoryGirl.create :student}
    #     let(:adv_profile){current_user.tep_advisor}
    #     subject{get :index, :student_id => stu.id}

    #     before do
    #         FactoryGirl.create :advisor_assignment, {:student_id => stu.id, :tep_advisor_id => adv_profile.id }
    #     end

    #     it "returns http success" do
    #         subject
    #         assert_response :success
    #     end
        
    #     describe "praxis" do

    #         let(:concern){assigns(:concerns)[:praxis]}

    #         it "pulls generic args" do
    #             subject
    #             expect concern[:title].must_equal "Praxis I"
    #             expect concern[:link].must_equal student_praxis_results_path(stu.id)
    #             expect concern[:link_title].must_equal "View Praxis Results"
    #             expect concern[:link_num].must_equal stu.praxis_results.size
    #         end

    #         it "pulls args for passing" do
    #             pop_praxisI(stu, true)
    #             subject
    #             expect concern[:alert_status].must_equal "success"
    #             expect concern[:glyph].must_equal "ok-sign"

    #         end

    #         it "pulls args for not passing" do
    #             pop_praxisI(stu, false)
    #             subject
    #             expect concern[:alert_status].must_equal "danger"
    #             expect concern[:glyph].must_equal "warning-sign" 
    #         end

    #         it "pulls args for no test" do
    #             subject
    #             expect concern[:alert_status].must_equal "info"
    #             expect concern[:glyph].must_equal "question-sign" 
    #         end
    #     end #praxis


    #     describe "issues" do

    #         let(:concern){assigns(:concerns)[:issues]}

    #         it "pulls args for open issue" do
                
    #             FactoryGirl.create :issue, {:student_id => stu.id, :Open => true}
    #             subject
    #             expect concern[:title].must_equal "Advisor Notes"
    #             expect concern[:link].must_equal student_issues_path(stu.id)
    #             expect concern[:link_title].must_equal "View Advisor Notes"
    #             expect concern[:link_num].must_equal stu.issues.size
    #             expect concern[:alert_status].must_equal "danger"
    #             expect concern[:glyph].must_equal "warning-sign"
    #         end

    #         it "pulls nothing for no issue" do
    #             subject
    #             expect concern.must_equal nil
    #         end

    #     end

    # end


end
