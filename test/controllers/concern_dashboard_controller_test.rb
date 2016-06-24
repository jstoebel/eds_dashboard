require 'test_helper'
require 'test_teardown'
class ConcernDashboardControllerTest < ActionController::TestCase
    include TestTeardown

    allowed_roles = ["admin", "advisor"]

    let(:stu){FactoryGirl.create :student}
    let(:adv_profile){current_user.tep_advisor}
    subject{get :index, :student_id => stu.id}

    before do
        FactoryGirl.create :advisor_assignment, {:student_id => stu.id, :tep_advisor_id => adv_profile.id }
    end

    it "returns http success" do
    end


    describe "index success" do

        let(:stu){FactoryGirl.create :student}
        let(:adv_profile){current_user.tep_advisor}
        subject{get :index, :student_id => stu.id}

        before do
            FactoryGirl.create :advisor_assignment, {:student_id => stu.id, :tep_advisor_id => adv_profile.id }
        end

        it "returns http success" do
            subject
            assert_response :success
        end
        
        describe "praxis" do

            let(:concern){assigns(:concerns)[:praxis]}

            it "pulls generic args" do
                subject
                expect concern[:title].must_equal "Praxis I"
                expect concern[:link].must_equal student_praxis_results_path(stu.id)
                expect concern[:link_title].must_equal "View Praxis Results"
                expect concern[:link_num].must_equal stu.praxis_results.size
            end

            it "pulls args for passing" do
                pop_praxisI(stu, true)
                subject
                expect concern[:alert_status].must_equal "success"
                expect concern[:glyph].must_equal "ok-sign"

            end

            it "pulls args for not passing" do
                pop_praxisI(stu, false)
                subject
                expect concern[:alert_status].must_equal "danger"
                expect concern[:glyph].must_equal "warning-sign" 
            end

            it "pulls args for no test" do
                subject
                expect concern[:alert_status].must_equal "info"
                expect concern[:glyph].must_equal "question-sign" 
            end
        end #praxis


        describe "issues" do

            let(:concern){assigns(:concerns)[:issues]}

            it "pulls args for open issue" do
                
                FactoryGirl.create :issue, {:student_id => stu.id, :Open => true}
                subject
                expect concern[:title].must_equal "Advisor Notes"
                expect concern[:link].must_equal student_issues_path(stu.id)
                expect concern[:link_title].must_equal "View Advisor Notes"
                expect concern[:link_num].must_equal stu.issues.size
                expect concern[:alert_status].must_equal "danger"
                expect concern[:glyph].must_equal "warning-sign"
            end

            it "pulls nothing for no issue" do
                subject
                expect concern.must_equal nil
            end

        end

    end


end
