require 'test_helper'
require 'test_teardown'

class AdvisorAssignmentsControllerTest < ActionController::TestCase

  before do
    @controller = Api::V1::AdvisorAssignmentsController.new
    @before_count = AdvisorAssignment.all.size
  end

  describe "create success" do

    let(:stu){FactoryGirl.create :student}
    let(:usr){FactoryGirl.create :advisor}
    let(:adv){usr.tep_advisor}
    let(:assignment_diff){AdvisorAssignment.all.size - @before_count}

    it "adds new assignments" do
        patch :update, {:student_id => stu.id, :advisors => [adv.attributes.slice("AdvisorBnum", "name")]}
        # patch :update, {:student_id => stu.id, :advisors => [adv.AdvisorBnum] }
        expect assignment_diff.must_equal 1
    end

    it "removes advisors" do
        AdvisorAssignment.create({
                :student_id => stu.id,
                :tep_advisor_id => adv.id
        })
        patch :update, {:student_id => stu.id, :advisors => []} #delete all assignments
        expect assignment_diff.must_equal 0
    end

    it "returns http sucess" do
        patch :update, {:student_id => stu.id, :advisors => []}
        assert_response :created
    end

    it "returns a success message" do
        patch :update, {:student_id => stu.id, :advisors => []}
        message = JSON.parse(response.body)
        expect message["success"].must_equal true
        expect message["msg"].must_equal "Successfully altered advisor assignments."
        expect message["added"].must_equal []
        expect message["deleted"].must_equal []
        
    end

  end

  describe "create fail" do

    it "returns http fail" do
        patch :update, {:student_id => nil, :advisors => []}
        assert_response :unprocessable_entity
    end

    it "handles error message" do
        patch :update, {:student_id => nil, :advisors => []}    
        message = JSON.parse(response.body)
        expect message["success"].must_equal false
        expect message["msg"].must_equal "Couldn't find Student without an ID"

    end

  end

end